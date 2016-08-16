( function( ) {

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

    require( '../abase/component/Path.s' );

  }

  _global_.wTests = typeof wTests === 'undefined' ? {} : wTests;

  var _ = wTools;
  var Self = {};

  //

  var _pathJoin = function( test )
  {
    var options1 =
      {
        reroot: 1,
        url: 0
      },
      options2 =
      {
        reroot: 0,
        url: 1
      },
      options3 =
      {
        reroot: 0
      },

      paths1 = [ 'http://www.site.com:13/', 'bar', 'foo', ],
      paths2 = [ 'c:\\', 'foo\\', 'bar\\' ],
      paths3 = [ '/bar/', '/', 'foo/' ],
      paths4 = [ '/bar/', '/baz', 'foo/' ],

      expected1 = 'http://www.site.com:13/bar/foo',
      expected2 = 'c:/foo/bar/',
      expected3 = '/foo/',
      expected4 = '/bar/baz/foo/';


    test.description = 'join url';
    var got = _._pathJoin( paths1, options2 );
    test.contain( got, expected1 );

    test.description = 'join windows os paths';
    var got = _._pathJoin( paths2, options3 );
    test.contain( got, expected2 );

    test.description = 'join unix os paths';
    var got = _._pathJoin( paths3, options3 );
    test.contain( got, expected3 );

    test.description = 'join unix os paths with reroot';
    var got = _._pathJoin( paths4, options1 );
    test.contain( got, expected4 );

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
        _._pathJoin( [ 34 , 'foo/' ], options3 );
      });

      test.description = 'missed options';
      test.shouldThrowError( function()
      {
        _._pathJoin( paths1 );
      });

      test.description = 'options has unexpected parameters';
      test.shouldThrowError( function()
      {
        _._pathJoin( paths1, { wrongParameter: 1 } );
      });

    }


  };

  //

  var pathJoin = function( test )
  {
    var paths1 = [ 'c:\\', 'foo\\', 'bar\\' ],
      paths2 = [ '/bar/', '/baz', 'foo/', '.' ],
      expected1 = 'c:/foo/bar/',
      expected2 = '/baz/foo/';

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
    var paths1 = [ 'c:\\', 'foo\\', 'bar\\' ],
      paths2 = [ '/bar/', '/baz', 'foo/', '.' ],
      expected1 = 'c:/foo/bar/',
      expected2 = '/bar/baz/foo/.';

    test.description = 'missed arguments';
    var got = _.pathReroot();
    test.contain( got, '' );

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

  var pathDir = function( test )
  {
    var path1 = '',
      path2 = '/foo',
      path3 = '/foo/bar/baz/text.txt',
      path4 = 'c:/',
      path5 = 'a:/foo/baz/bar.txt',
      expected1 = '',
      expected2 = '/',
      expected3 = '/foo/bar/baz',
      expected4 = 'c:',
      expected5 = 'a:/foo/baz';

    test.description = 'empty path';
    var got = _.pathDir( path1 );
    test.identical( got, expected1);

    test.description = 'simple path';
    var got = _.pathDir( path2 );
    test.identical( got, expected2);

    test.description = 'simple path: nested dirs ';
    var got = _.pathDir( path3 );
    test.identical( got, expected3);

    test.description = 'windows os path';
    var got = _.pathDir( path4 );
    test.identical( got, expected4);

    test.description = 'windows os path: nested dirs';
    var got = _.pathDir( path5 );
    test.identical( got, expected5);

    if( Config.debug )
    {
      test.description = 'passed argument is non string';
      test.shouldThrowError( function()
      {
        _.pathDir( {} );
      });
    }
  };

  var pathExt = function( test ) {
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
      expected4 = '/foo/bar/.baz',
      expected5 = '/foo.coffee',
      expected6 = '/foo/bar/baz';

    test.description = 'empty path';
    var got = _.pathPrefix( path1 );
    test.identical( got, expected1 );

    test.description = 'txt extension';
    var got = _.pathPrefix( path2 );
    test.identical( got, expected2 );

    test.description = 'path with non empty dir name';
    var got = _.pathPrefix( path3 );
    test.identical( got, expected3) ;

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
    var got = _.pathName( path2, { withExtension: 1 } );
    test.identical( got, expected2 );

    test.description = 'got file without extension';
    var got = _.pathName( path3, { withoutExtension: 1 } );
    test.identical( got, expected3) ;

    test.description = 'hidden file';
    var got = _.pathName( path4, { withExtension: 1 } );
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
      expected7 = '/foo/baz.bar/some';

    debugger;
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

  // --
  // proto
  // --

  var Proto =
  {

    name : 'PathTest',

    tests:
    {

      _pathJoin: _pathJoin,
      pathJoin: pathJoin,
      pathReroot: pathReroot,
      pathDir: pathDir,
      pathExt: pathExt,
      pathPrefix: pathPrefix,
      pathName: pathName,
      pathWithoutExt: pathWithoutExt,
      pathChangeExt: pathChangeExt

    },

    verbose : 0,

  };

  Object.setPrototypeOf( Self, Proto );
  wTests[ Self.name ] = Self;

  if( typeof module !== 'undefined' && !module.parent )
  _.testing.test( Self );

} )( );
