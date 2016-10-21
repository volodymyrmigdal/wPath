( function _Path_path_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  try
  {
    require( '../ServerTools.ss' );
  }
  catch( err )
  {
  }

  try
  {
    require( '../wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  try
  {
    require( 'include/abase/object/Testing.debug.s' );
  }
  catch( err )
  {
    require( 'wTesting' );
  }

  require( '../component/Path.s' );

}

_global_.wTests = typeof wTests === 'undefined' ? {} : wTests;

var _ = wTools;
var Self = {};

//

var pathJoin = function( test )
{
  var paths1 = [ 'c :\\', 'foo\\', 'bar\\' ],
    paths2 = [ '/bar/', '/baz', 'foo/', '.' ],
    expected1 = 'c :/foo/bar/',
    expected2 = '/baz/foo/.';

  test.description = 'missed arguments';
  var got = _.pathJoin();
  test.contain( got, '.' );

  test.description = 'join windows os paths';
  var got = _.pathJoin.apply( _, paths1 );
  test.contain( got, expected1 );

  test.description = 'join unix os paths';
  var got = _.pathJoin.apply( _, paths2 );
  test.contain( got, expected2 );

  if( Config.debug )
  {
    test.description = 'non string passed';
    test.shouldThrowError( function()
    {
      _.pathJoin( {} );
    });
  }

};

//

var pathReroot = function( test )
{
  var paths1 = [ 'c :\\', 'foo\\', 'bar\\' ],
    paths2 = [ '/bar/', '/baz', 'foo/', '.' ],
    expected1 = 'c :/foo/bar/',
    expected2 = '/bar/baz/foo/.';

  test.description = 'missed arguments';
  var got = _.pathReroot();
  test.contain( got, '.' );

  test.description = 'join windows os paths';
  var got = _.pathReroot.apply( _, paths1 );
  test.contain( got, expected1 );

  test.description = 'join unix os paths';
  var got = _.pathReroot.apply( _, paths2 );
  test.contain( got, expected2 );

  if( Config.debug )
  {
    test.description = 'non string passed';
    test.shouldThrowError( function()
    {
      _.pathReroot( {} );
    });
  }

};

//

var _pathJoin = function( test )
{

  var options1 =
    {
      reroot : 1,
      url : 0
    },
    options2 =
    {
      reroot : 0,
      url : 1
    },
    options3 =
    {
      reroot : 0
    },

    paths1 = [ 'http://www.site.com:13/', 'bar', 'foo', ],
    paths2 = [ 'c :\\', 'foo\\', 'bar\\' ],
    paths3 = [ '/bar/', '/', 'foo/' ],
    paths4 = [ '/bar/', '/baz', 'foo/' ],

    expected1 = 'http://www.site.com:13/bar/foo',
    expected2 = 'c :/foo/bar/',
    expected3 = '/foo/',
    expected4 = '/bar/baz/foo/';

  test.description = 'join url';
  var got = _._pathJoin( _.mapSupplement( { paths : paths1 },options2 ) );
  test.identical( got, expected1 );

  test.description = 'join windows os paths';
  var got = _._pathJoin( _.mapSupplement( { paths : paths2 },options3 ) );
  test.identical( got, expected2 );

  test.description = 'join unix os paths';
  var got = _._pathJoin( _.mapSupplement( { paths : paths3 },options3 ) );
  test.identical( got, expected3 );

  test.description = 'join unix os paths with reroot';
  var got = _._pathJoin( _.mapSupplement( { paths : paths4 },options1 ) );
  test.identical( got, expected4 );

  test.description = 'join reroot with /';
  var got = _._pathJoin
  ({
    paths : [ '/','/a/b' ],
    reroot : 1,
  });
  test.identical( got, '/a/b' );

  if( Config.debug )
  {

    test.description = 'missed arguments';
    test.shouldThrowError( function()
    {
      _._pathJoin();
    });

    test.description = 'path element is not string';
    test.shouldThrowError( function()
    {
      _._pathJoin( _.mapSupplement( { paths : [ 34 , 'foo/' ] },options3 ) );
    });

    test.description = 'missed options';
    test.shouldThrowError( function()
    {
      _._pathJoin( paths1 );
    });

    test.description = 'options has unexpected parameters';
    test.shouldThrowError( function()
    {
      _._pathJoin({ paths : paths1, wrongParameter : 1 });
    });

    test.description = 'options does not has paths';
    test.shouldThrowError( function()
    {
      _._pathJoin({ wrongParameter : 1 });
    });

  }


};

//

var pathDir = function( test )
{
  var
    path2 = '/foo',
    path3 = '/foo/bar/baz/text.txt',
    path4 = 'c:/',
    path5 = 'a:/foo/baz/bar.txt',
    expected1 = '',
    expected2 = '/',
    expected3 = '/foo/bar/baz',
    expected4 = 'c:/..',
    expected5 = 'a:/foo/baz';

  test.description = 'simple path';
  var got = _.pathDir( path2 );
  test.identical( got, expected2 );

  test.description = 'simple path : nested dirs ';
  var got = _.pathDir( path3 );
  test.identical( got, expected3 );

  test.description = 'windows os path';
  var got = _.pathDir( path4 );
  test.identical( got, expected4 );

  test.description = 'windows os path : nested dirs';
  var got = _.pathDir( path5 );
  test.identical( got, expected5 );

  if( Config.debug )
  {

    test.description = 'empty path';
    test.shouldThrowError( function()
    {
      var got = _.pathDir( '' );
    });

    test.description = 'redundant argument';
    test.shouldThrowError( function()
    {
      var got = _.pathDir( 'a','b' );
    });

    test.description = 'passed argument is non string';
    test.shouldThrowError( function()
    {
      _.pathDir( {} );
    });
  }
};

//

var pathExt = function( test )
{
  var path1 = '',
    path2 = 'some.txt',
    path3 = '/foo/bar/baz.asdf',
    path4 = '/foo/bar/.baz',
    path5 = '/foo.coffee.md',
    path6 = '/foo/bar/baz',
    expected1 = '',
    expected2 = 'txt',
    expected3 = 'asdf',
    expected4 = '',
    expected5 = 'md',
    expected6 = '';

  test.description = 'empty path';
  var got = _.pathExt( path1 );
  test.identical( got, expected1 );

  test.description = 'txt extension';
  var got = _.pathExt( path2 );
  test.identical( got, expected2 );

  test.description = 'path with non empty dir name';
  var got = _.pathExt( path3 );
  test.identical( got, expected3) ;

  test.description = 'hidden file';
  var got = _.pathExt( path4 );
  test.identical( got, expected4 );

  test.description = 'several extension';
  var got = _.pathExt( path5 );
  test.identical( got, expected5 );

  test.description = 'file without extension';
  var got = _.pathExt( path6 );
  test.identical( got, expected6 );

  if( Config.debug )
  {
    test.description = 'passed argument is non string';
    test.shouldThrowError( function()
    {
      _.pathExt( null );
    });
  }
};

//

var pathPrefix = function( test )
{
  var path1 = '',
    path2 = 'some.txt',
    path3 = '/foo/bar/baz.asdf',
    path4 = '/foo/bar/.baz',
    path5 = '/foo.coffee.md',
    path6 = '/foo/bar/baz',
    expected1 = '',
    expected2 = 'some',
    expected3 = '/foo/bar/baz',
    expected4 = '/foo/bar/',
    expected5 = '/foo',
    expected6 = '/foo/bar/baz';

  test.description = 'empty path';
  var got = _.pathPrefix( path1 );
  test.identical( got, expected1 );

  test.description = 'txt extension';
  var got = _.pathPrefix( path2 );
  test.identical( got, expected2 );

  test.description = 'path with non empty dir name';
  var got = _.pathPrefix( path3 );
  test.identical( got, expected3 ) ;

  test.description = 'hidden file';
  var got = _.pathPrefix( path4 );
  test.identical( got, expected4 );

  test.description = 'several extension';
  var got = _.pathPrefix( path5 );
  test.identical( got, expected5 );

  test.description = 'file without extension';
  var got = _.pathPrefix( path6 );
  test.identical( got, expected6 );

  if( Config.debug )
  {
    test.description = 'passed argument is non string';
    test.shouldThrowError( function()
    {
      _.pathPrefix( null );
    });
  }
};

//

var pathName = function( test )
{
  var path1 = '',
    path2 = 'some.txt',
    path3 = '/foo/bar/baz.asdf',
    path4 = '/foo/bar/.baz',
    path5 = '/foo.coffee.md',
    path6 = '/foo/bar/baz',
    expected1 = '',
    expected2 = 'some.txt',
    expected3 = 'baz',
    expected4 = '.baz',
    expected5 = 'foo.coffee',
    expected6 = 'baz';

  test.description = 'empty path';
  var got = _.pathName( path1 );
  test.identical( got, expected1 );

  test.description = 'get file with extension';
  var got = _.pathName( path2, { withExtension : 1 } );
  test.identical( got, expected2 );

  test.description = 'got file without extension';
  var got = _.pathName( path3, { withoutExtension : 1 } );
  test.identical( got, expected3) ;

  test.description = 'hidden file';
  var got = _.pathName( path4, { withExtension : 1 } );
  test.identical( got, expected4 );

  test.description = 'several extension';
  var got = _.pathName( path5 );
  test.identical( got, expected5 );

  test.description = 'file without extension';
  var got = _.pathName( path6 );
  test.identical( got, expected6 );

  if( Config.debug )
  {
    test.description = 'passed argument is non string';
    test.shouldThrowError( function()
    {
      _.pathName( false );
    });
  }
};

//

var pathWithoutExt = function( test )
{
  var path1 = '',
    path2 = 'some.txt',
    path3 = '/foo/bar/baz.asdf',
    path4 = '/foo/bar/.baz',
    path5 = '/foo.coffee.md',
    path6 = '/foo/bar/baz',
    expected1 = '',
    expected2 = 'some',
    expected3 = '/foo/bar/baz',
    expected4 = '/foo/bar/.baz',
    expected5 = '/foo.coffee',
    expected6 = '/foo/bar/baz';

  test.description = 'empty path';
  var got = _.pathWithoutExt( path1 );
  test.identical( got, expected1 );

  test.description = 'txt extension';
  var got = _.pathWithoutExt( path2 );
  test.identical( got, expected2 );

  test.description = 'path with non empty dir name';
  var got = _.pathWithoutExt( path3 );
  test.identical( got, expected3) ;

  test.description = 'hidden file';
  var got = _.pathWithoutExt( path4 );
  test.identical( got, expected4 );

  test.description = 'file with composite file name';
  var got = _.pathWithoutExt( path5 );
  test.identical( got, expected5 );

  test.description = 'path without extension';
  var got = _.pathWithoutExt( path6 );
  test.identical( got, expected6 );

  if( Config.debug )
  {
    test.description = 'passed argument is non string';
    test.shouldThrowError( function()
    {
      _.pathWithoutExt( null );
    });
  }
};

//

var pathChangeExt = function( test )
{
  var path1 = 'some.txt',
    ext1 = '',
    path2 = 'some.txt',
    ext2 = 'json',
    path3 = '/foo/bar/baz.asdf',
    ext3 = 'txt',
    path4 = '/foo/bar/.baz',
    ext4 = 'sh',
    path5 = '/foo.coffee.md',
    ext5 = 'min',
    path6 = '/foo/bar/baz',
    ext6 = 'txt',
    path7 = '/foo/baz.bar/some.md',
    ext7 = 'txt',
    expected1 = 'some',
    expected2 = 'some.json',
    expected3 = '/foo/bar/baz.txt',
    expected4 = '/foo/bar/.baz.sh',
    expected5 = '/foo.coffee.min',
    expected6 = '/foo/bar/baz.txt',
    expected7 = '/foo/baz.bar/some.txt';

  test.description = 'empty ext';
  var got = _.pathChangeExt( path1, ext1 );
  test.identical( got, expected1 );

  test.description = 'simple change extension';
  var got = _.pathChangeExt( path2, ext2 );
  test.identical( got, expected2 );

  test.description = 'path with non empty dir name';
  var got = _.pathChangeExt( path3, ext3 );
  test.identical( got, expected3) ;

  test.description = 'change extension of hidden file';
  var got = _.pathChangeExt( path4, ext4 );
  test.identical( got, expected4 );

  test.description = 'change extension in composite file name';
  var got = _.pathChangeExt( path5, ext5 );
  test.identical( got, expected5 );

  test.description = 'add extension to file without extension';
  var got = _.pathChangeExt( path6, ext6 );
  test.identical( got, expected6 );

  test.description = 'path folder contains dot, file without extension';
  var got = _.pathChangeExt( path7, ext7 );
  test.identical( got, expected7 );

  if( Config.debug )
  {
    test.description = 'passed argument is non string';
    test.shouldThrowError( function()
    {
      _.pathChangeExt( null, ext1 );
    });
  }
};

//

var pathNormalize = function( test )
{
  var path1 = '/foo/bar//baz/asdf/quux/..',
    expected1 = '/foo/bar/baz/asdf',
    path2 = 'C:\\temp\\\\foo\\bar\\..\\',
    expected2 = 'C:/temp//foo/bar/../',
    path3 = '',
    expected3 = '.',
    path4 = 'foo/./bar/baz/',
    expected4 = 'foo/bar/baz/',
    got;

  test.description = 'posix path';
  got = _.pathNormalize( path1 );
  test.identical( got, expected1 );

  test.description = 'winoows path';
  got = _.pathNormalize( path2 );
  test.identical( got, expected2 );

  test.description = 'empty path';
  got = _.pathNormalize( path3 );
  test.identical( got, expected3 );

  test.description = 'path with "." section';
  got = _.pathNormalize( path4 );
  test.identical( got, expected4 );

};

//

var pathRelative = function( test )
{
  var pathFrom1 = '/foo/bar/baz/asdf/quux',
    pathTo1 = '/foo/bar/baz/asdf/quux',
    expected1 = '.',

    pathFrom2 = '/foo/bar/baz/asdf/quux',
    pathTo2 = '/foo/bar/baz/asdf/quux/new1',
    expected2 = 'new1',

    pathFrom3 = '/foo/bar/baz/asdf/quux',
    pathTo3 = '/foo/bar/baz/asdf',
    expected3 = '..',

    pathFrom4 = '/foo/bar/baz/asdf/quux/dir1/dir2',
    pathTo4 =
    [
      '/foo/bar/baz/asdf/quux/dir1/dir2',
      '/foo/bar/baz/asdf/quux/dir1/',
      '/foo/bar/baz/asdf/quux/',
      '/foo/bar/baz/asdf/quux/dir1/dir2/dir3'
    ],
    expected4 = [ '.', '..', '../..', 'dir3' ],

    path5 = 'tmp/pathRelative/foo/bar/test',
    pathTo5 = 'tmp/pathRelative/foo/',
    expected5 = '../..',

    got;

  test.description = 'relative to same path';
  got = _.pathRelative( pathFrom1, pathTo1 );
  test.identical( got, expected1 );

  test.description = 'relative to nested';
  got = _.pathRelative( pathFrom2, pathTo2 );
  test.identical( got, expected2 );

  test.description = 'relative to parent directory';
  got = _.pathRelative( pathFrom3, pathTo3 );
  test.identical( got, expected3 );

  test.description = 'relative to array of paths';
  got = _.pathRelative( pathFrom4, pathTo4 );
  test.identical( got, expected4 );

  test.description = 'using file record';
  createTestFile( path5 );
  var fr = FileRecord( Path.resolve( mergePath( path5 ) ) );
  got =  _.pathRelative( fr, Path.resolve( mergePath( pathTo5 ) ) );
  test.identical( got, expected5 );

  if( Config.debug )
  {
    test.pathRelative = 'missed arguments';
    test.shouldThrowError( function( )
    {
      _.pathRelative( pathFrom1 );
    } );

    test.description = 'extra arguments';
    test.shouldThrowError( function( )
    {
      _.pathRelative( pathFrom3, pathTo3, pathTo4 );
    } );

    test.description = 'second argument is not string or array';
    test.shouldThrowError( function( )
    {
      _.pathRelative( pathFrom3, null );
    } );
  }

};

//

var pathResolve = function( test ) {
  var paths1 = [ '/foo', 'bar/', 'baz' ],
    expected1 = '/foo/bar/baz',

    paths2 = [ '/foo', '/bar/', 'baz' ],
    expected2 = '/bar/baz',

    path3 = '/foo/bar/baz/asdf/quux',
    expected3 = '/foo/bar/baz/asdf/quux',
    got;

  test.description = 'several part of path';
  got = _.pathResolve.apply( _, paths1 );
  test.identical( got, expected1 );

  test.description = 'with root';
  got = _.pathResolve.apply( _, paths2 );
  test.identical( got, expected2 );

  test.description = 'one absolute path';
  got = _.pathResolve( path3 );
  test.identical( got, expected3 );
};

//

var pathIsSafe = function( test )
{
  var path1 = '/home/user/dir1/dir2',
    path2 = 'C:/foo/baz/bar',
    path3 = '/foo/bar/.hidden',
    path4 = '/foo/./somedir',
    path5 = 'c:foo/',
    got;

  test.description = 'safe posix path';
  got = _.pathIsSafe( path1 );
  test.identical( got, true );

  test.description = 'safe windows path';
  got = _.pathIsSafe( path2 );
  test.identical( got, true );

  test.description = 'unsafe posix path ( hidden )';
  got = _.pathIsSafe( path3 );
  test.identical( got, false );

  test.description = 'safe posix path with "." segment';
  got = _.pathIsSafe( path4 );
  test.identical( got, true );

  test.description = 'unsafe windows path';
  got = _.pathIsSafe( path5 );
  test.identical( got, false );

  if( Config.debug )
  {
    test.pathRelative = 'missed arguments';
    test.shouldThrowError( function( )
    {
      _.pathIsSafe( );
    } );

    test.description = 'second argument is not string';
    test.shouldThrowError( function( )
    {
      _.pathIsSafe( null );
    } );
  }
};

//

var pathRegexpSafeShrink = function( test )
{
  var expected1 =
    {
      includeAny: [],
      includeAll: [],
      excludeAny: [
        /node_modules/,
        /\.unique/,
        /\.git/,
        /\.svn/,
        /(^|\/)\.(?!$|\/)/,
        /(^|\/)-(?!$|\/)/
      ],
      excludeAll: []
    },

    path2 = 'foo/bar',
    expected2 =
    {
      includeAny: [ /foo\/bar/ ],
      includeAll: [],
      excludeAny: [
        /node_modules/,
        /\.unique/,
        /\.git/,
        /\.svn/,
        /(^|\/)\.(?!$|\/)/,
        /(^|\/)-(?!$|\/)/,
      ],
      excludeAll: []
    },

    path3 = [ 'foo/bar', 'foo2/bar2/baz', 'some.txt' ],
    expected3 =
    {
      includeAny: [ /foo\/bar/, /foo2\/bar2\/baz/, /some\.txt/ ],
      includeAll: [],
      excludeAny: [
        /node_modules/,
        /\.unique/,
        /\.git/,
        /\.svn/,
        /(^|\/)\.(?!$|\/)/,
        /(^|\/)-(?!$|\/)/,
      ],
      excludeAll: []
    },

    paths4 = {
      includeAny: [ 'foo/bar', 'foo2/bar2/baz', 'some.txt' ],
      includeAll: [ 'index.js' ],
      excludeAny: [ 'Gruntfile.js', 'gulpfile.js' ],
      excludeAll: [ 'package.json', 'bower.json' ]
    },
    expected4 =
    {
      includeAny: [ /foo\/bar/, /foo2\/bar2\/baz/, /some\.txt/ ],
      includeAll: [ /index\.js/ ],
      excludeAny: [
        /Gruntfile\.js/,
        /gulpfile\.js/,
        /node_modules/,
        /\.unique/,
        /\.git/,
        /\.svn/,
        /(^|\/)\.(?!$|\/)/,
        /(^|\/)-(?!$|\/)/
      ],
      excludeAll: [ /package\.json/, /bower\.json/ ]
    },
    got;

  test.description = 'only default safe paths';
  got = _.pathRegexpSafeShrink( );
  getSourceFromMap( got );
  getSourceFromMap( expected1 );
  test.identical( got, expected1 );

  test.description = 'single path for include any mask';
  got = _.pathRegexpSafeShrink( path2 );
  getSourceFromMap( got );
  getSourceFromMap( expected2 );
  test.identical( got, expected2 );

  test.description = 'array of paths for include any mask';
  got = _.pathRegexpSafeShrink( path3 );
  getSourceFromMap( got );
  getSourceFromMap( expected3 );
  test.identical( got, expected3 );

  test.description = 'regex object passed as mask for include any mask';
  got = _.pathRegexpSafeShrink( paths4 );
  getSourceFromMap( got );
  getSourceFromMap( expected4 );
  test.identical( got, expected4 );

  if( Config.debug )
  {
    test.pathRelative = 'extra arguments';
    test.shouldThrowError( function( )
    {
      _.pathRegexpSafeShrink( 'package.json', 'bower.json' );
    } );
  }
};

// --
// proto
// --

var Proto =
{

  name : 'PathTest',

  tests :
  {

    pathJoin : pathJoin,
    pathReroot : pathReroot,
    _pathJoin : _pathJoin,

    pathDir : pathDir,
    pathExt : pathExt,
    pathPrefix : pathPrefix,
    pathName : pathName,
    pathWithoutExt : pathWithoutExt,
    pathChangeExt : pathChangeExt,

    pathNormalize : pathNormalize,
    pathRelative : pathRelative,
    pathResolve : pathResolve,
    pathIsSafe : pathIsSafe,

  },

  verbose : 0,

};

Object.setPrototypeOf( Self, Proto );
wTests[ Self.name ] = Self;

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self );

} )( );
