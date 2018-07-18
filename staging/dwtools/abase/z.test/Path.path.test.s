( function _Path_path_test_s_( ) {

'use strict';

var isBrowser = true;

if( typeof module !== 'undefined' )
{
  isBrowser = false;

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wTesting' );
  require( '../layer3/aPathTools.s' );

}

var _global = _global_; var _ = _global_.wTools;

//

function pathRefine( test )
{

  var got;

  test.case = 'posix path'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar//baz/asdf/quux/..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar//baz/asdf/quux/..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '//foo/bar//baz/asdf/quux/..//';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar//baz/asdf/quux/..//.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  test.case = 'winoows path'; /* */

  var path = 'C:\\';
  var expected = '/C';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'C:';
  var expected = '/C';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp//foo/bar/..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo/bar/..//';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo/bar/..//';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp//foo/bar/../..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp//foo/bar/../../.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  test.case = 'empty path'; /* */

  var path = '';
  var expected = '.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '//';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '///';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/./.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = './.';
  var expected = './.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  test.case = 'path with "." in the middle'; /* */

  var path = 'foo/./bar/baz';
  var expected = 'foo/./bar/baz';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/././bar/baz';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/././bar/././baz';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/././bar/././baz';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  test.case = 'path with "." in the beginning'; /* */

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = '././foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = './/.//foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '/.//.//foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  test.case = 'path with "." in the end'; /* */

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar/.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar/./.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar/./.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar/./.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle'; /* */

  var path = 'foo/../bar/baz';
  var expected = 'foo/../bar/baz';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = 'foo/../../bar/baz';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = 'foo/../../bar/../../baz';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/foo/../../bar/../../baz';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning'; /* */

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '..//..//foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/..//..//foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the end'; /* */

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo/bar/..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = 'foo/bar/../..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = 'foo/bar/../..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/foo/bar/../..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

}

//

function pathsRefine( test )
{

  var got;

  var cases =
  [
    {
      description : 'posix path',
      src :
      [
        '/foo/bar//baz/asdf/quux/..',
        '/foo/bar//baz/asdf/quux/../',
        '//foo/bar//baz/asdf/quux/..//',
        'foo/bar//baz/asdf/quux/..//.',
      ],
      expected :
      [
        '/foo/bar//baz/asdf/quux/..',
        '/foo/bar//baz/asdf/quux/..',
        '//foo/bar//baz/asdf/quux/..//',
        'foo/bar//baz/asdf/quux/..//.'
       ]
    },
    {
      description : 'winoows path',
      src :
      [
        'C:\\temp\\\\foo\\bar\\..\\',
        'C:\\temp\\\\foo\\bar\\..\\\\',
        'C:\\temp\\\\foo\\bar\\..\\\\.',
        'C:\\temp\\\\foo\\bar\\..\\..\\',
        'C:\\temp\\\\foo\\bar\\..\\..\\.'
      ],
      expected :
      [
        '/C/temp//foo/bar/..',
        '/C/temp//foo/bar/..//',
        '/C/temp//foo/bar/..//.',
        '/C/temp//foo/bar/../..',
        '/C/temp//foo/bar/../../.'
      ]
    },
    {
      description : 'empty path',
      src :
      [
        '',
        '/',
        '//',
        '///',
        '/.',
        '/./.',
        '.',
        './.'
      ],
      expected :
      [
        '.',
        '/',
        '//',
        '///',
        '/.',
        '/./.',
        '.',
        './.'
      ]
    },
    {
      description : 'path with "." in the middle',
      src :
      [
        'foo/./bar/baz',
        'foo/././bar/baz/',
        'foo/././bar/././baz/',
        '/foo/././bar/././baz/'
      ],
      expected :
      [
        'foo/./bar/baz',
        'foo/././bar/baz',
        'foo/././bar/././baz',
        '/foo/././bar/././baz'
      ]
    },
    {
      description : 'path with "." in the beginning',
      src :
      [
        './foo/bar',
        '././foo/bar/',
        './/.//foo/bar/',
        '/.//.//foo/bar/',
        '.x/foo/bar',
        '.x./foo/bar'
      ],
      expected :
      [
        './foo/bar',
        '././foo/bar',
        './/.//foo/bar',
        '/.//.//foo/bar',
        '.x/foo/bar',
        '.x./foo/bar'
      ]
    },
    {
      description : 'path with "." in the end',
      src :
      [
        'foo/bar.',
        'foo/.bar.',
        'foo/bar/.',
        'foo/bar/./.',
        'foo/bar/././',
        '/foo/bar/././'
      ],
      expected :
      [
        'foo/bar.',
        'foo/.bar.',
        'foo/bar/.',
        'foo/bar/./.',
        'foo/bar/./.',
        '/foo/bar/./.'
      ]
    },
    {
      description : 'path with ".." in the middle',
      src :
      [
        'foo/../bar/baz',
        'foo/../../bar/baz/',
        'foo/../../bar/../../baz/',
        '/foo/../../bar/../../baz/',
      ],
      expected :
      [
        'foo/../bar/baz',
        'foo/../../bar/baz',
        'foo/../../bar/../../baz',
        '/foo/../../bar/../../baz'
      ]
    },
    {
      description : 'path with ".." in the beginning',
      src :
      [
        '../foo/bar',
        '../../foo/bar/',
        '..//..//foo/bar/',
        '/..//..//foo/bar/',
        '..x/foo/bar',
        '..x../foo/bar'
      ],
      expected :
      [
        '../foo/bar',
        '../../foo/bar',
        '..//..//foo/bar',
        '/..//..//foo/bar',
        '..x/foo/bar',
        '..x../foo/bar'
      ]
    },
    {
      description : 'path with ".." in the end',
      src :
      [
        'foo/bar..',
        'foo/..bar..',
        'foo/bar/..',
        'foo/bar/../..',
        'foo/bar/../../',
        '/foo/bar/../../'
      ],
      expected :
      [
        'foo/bar..',
        'foo/..bar..',
        'foo/bar/..',
        'foo/bar/../..',
        'foo/bar/../..',
        '/foo/bar/../..'
      ]
    },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    test.case = c.description;
    test.identical( _.pathsRefine( c.src ), c.expected );
  }
}

//

function pathIsRefined( test )
{
  test.case = 'posix path, not refined'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  test.case = 'posix path, refined'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  test.case = 'winoows path, not refined'; /* */

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  test.case = 'winoows path, refined'; /* */

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  test.case = 'empty path,not refined';

  var path = '';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '/';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '//';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '///';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '.';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = './.';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  test.case = 'empty path,refined';

  var path = '';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '/';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '//';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '///';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '/.';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '/./.';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '.';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = './.';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  test.case = 'path with "." in the middle'; /* */

  var path = 'foo/./bar/baz';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  test.case = 'path with "." in the middle,refined';

  var path = 'foo/./bar/baz';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle'; /* */

  var path = 'foo/../bar/baz';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle,refined'; /* */

  var path = 'foo/../bar/baz';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning'; /* */

  var path = '../foo/bar';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning,refined';

  var path = '../foo/bar';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var refined = _.pathRefine( path );
  var expected = true;
  var got = _.pathIsRefined( refined );
  test.identical( got, expected );
}

//

function pathNormalize( test )
{

  var got;

  test.case = 'posix path'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar//baz/asdf';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar//baz/asdf';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '//foo/bar//baz/asdf//';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar//baz/asdf//';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  test.case = 'winoows path'; /* */

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp//foo';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo//';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp//foo//';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp//';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp//';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  test.case = 'empty path'; /* */

  var path = '';
  var expected = '.';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '//';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '///';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = './.';
  var expected = '.';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  test.case = 'path with "." in the middle'; /* */

  var path = 'foo/./bar/baz';
  var expected = 'foo/bar/baz';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/bar/baz';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/bar/baz';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/bar/baz';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/foo/.x./baz/';
  var expected = '/foo/.x./baz';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  test.case = 'path with "." in the beginning'; /* */

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = './foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  debugger
  var path = './/.//foo/bar/';
  var expected = './//foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '///foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = './x/.';
  var expected = './x';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  test.case = 'path with "." in the end'; /* */

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/foo/baz/.x./';
  var expected = '/foo/baz/.x.';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle'; /* */

  var path = 'foo/../bar/baz';
  var expected = 'bar/baz';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = '../bar/baz';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = '../../baz';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/../../baz';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning'; /* */

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '..//foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/..//foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the end'; /* */

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = '.';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = '.';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../..';
  var expected = '..';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../../..';
  var expected = '../..';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = 'foo/../bar/../../../..';
  var expected = '../../..';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  test.case = 'path with ".." and "." combined'; /* */

  var path = '/abc/./../a/b';
  var expected = '/a/b';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/abc/.././a/b';
  var expected = '/a/b';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/abc/./.././a/b';
  var expected = '/a/b';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/../.';
  var expected = '/a/b';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./..';
  var expected = '/a/b';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./../.';
  var expected = '/a/b';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = './../.';
  var expected = '..';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = './..';
  var expected = '..';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

  var path = '../.';
  var expected = '..';
  var got = _.pathNormalize( path );
  test.identical( got, expected );

}

//

function pathsNormalize( test )
{
  var cases =
  [
    {
      description : 'posix path',
      src :
      [
        '/foo/bar//baz/asdf/quux/..',
        '/foo/bar//baz/asdf/quux/../',
        '//foo/bar//baz/asdf/quux/..//',
        'foo/bar//baz/asdf/quux/..//.'
      ],
      expected :
      [
        '/foo/bar//baz/asdf',
        '/foo/bar//baz/asdf',
        '//foo/bar//baz/asdf//',
        'foo/bar//baz/asdf//'
      ]
    },
    {
      description : 'winoows path',
      src :
      [
        'C:\\temp\\\\foo\\bar\\..\\',
        'C:\\temp\\\\foo\\bar\\..\\\\',
        'C:\\temp\\\\foo\\bar\\..\\\\',
        'C:\\temp\\\\foo\\bar\\..\\..\\',
        'C:\\temp\\\\foo\\bar\\..\\..\\.'
      ],
      expected :
      [
        '/C/temp//foo',
        '/C/temp//foo//',
        '/C/temp//foo//',
        '/C/temp//',
        '/C/temp//'
      ]
    },
    {
      description : 'empty path',
      src :
      [
        '',
        '/',
        '//',
        '///',
        '/.',
        '/./.',
        '.',
        './.'
      ],
      expected :
      [
        '.',
        '/',
        '//',
        '///',
        '/',
        '/',
        '.',
        '.'
      ]
    },
    {
      description : 'path with "." in the middle',
      src :
      [
        'foo/./bar/baz',
        'foo/././bar/baz/',
        'foo/././bar/././baz/',
        '/foo/././bar/././baz/',
        '/foo/.x./baz/'
      ],
      expected :
      [
        'foo/bar/baz',
        'foo/bar/baz',
        'foo/bar/baz',
        '/foo/bar/baz',
        '/foo/.x./baz'
      ]
    },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    test.case = c.description;
    test.identical( _.pathsNormalize( c.src ), c.expected );
  }

}

//

function pathNormalizeTolerant( test )
{

  var got;

  test.case = 'posix path'; /* */

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '/foo/bar/baz/asdf/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar/baz/asdf/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'winoows path'; /* */

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp/foo/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'empty path'; /* */

  var path = '';
  var expected = '.';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = './.';
  var expected = '.';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with "." in the middle'; /* */

  var path = 'foo/./bar/baz';
  var expected = 'foo/bar/baz';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/bar/baz/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/bar/baz/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/bar/baz/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/.x./baz/';
  var expected = '/foo/.x./baz/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with "." in the beginning'; /* */

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = './foo/bar/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = './foo/bar/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '/foo/bar/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = './x/.';
  var expected = './x/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with "." in the end'; /* */

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/baz/.x./';
  var expected = '/foo/baz/.x./';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the middle'; /* */

  var path = 'foo/../bar/baz';
  var expected = 'bar/baz';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = '../bar/baz/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = '../../baz/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/../../baz/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the beginning'; /* */

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '../foo/bar/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/../foo/bar/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." in the end'; /* */

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = '/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = '.';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../..';
  var expected = '..';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../../..';
  var expected = '../..';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = 'foo/../bar/../../../..';
  var expected = '../../..';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  test.case = 'path with ".." and "." combined'; /* */

  var path = '/abc/./../a/b';
  var expected = '/a/b';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/abc/.././a/b';
  var expected = '/a/b';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/abc/./.././a/b';
  var expected = '/a/b';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/../.';
  var expected = '/a/b/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./..';
  var expected = '/a/b/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./../.';
  var expected = '/a/b/';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = './../.';
  var expected = '../';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = './..';
  var expected = '..';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

  var path = '../.';
  var expected = '../';
  var got = _.pathNormalizeTolerant( path );
  test.identical( got, expected );

}

//

function pathDot( test )
{
  var cases =
  [
    { src : '', expected : './' },
    { src : 'a', expected : './a' },
    { src : '.', expected : '.' },
    { src : '.a', expected : './.a' },
    { src : './a', expected : './a' },
    { src : '..', expected : '..' },
    { src : '..a', expected : './..a' },
    { src : '../a', expected : '../a' },
    { src : '/', error : true },
    { src : '/a', error : true },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.pathDot( c.src ) )
    }
    else
    test.identical( _.pathDot( c.src ), c.expected );
  }
}

//

function pathsDot( test )
{
  test.case = 'add ./ prefix'
  var cases =
  [
    {
      src :  [ '', 'a', '.', '.a', './a', '..', '..a', '../a',  ],
      expected : [ './', './a', '.', './.a', './a', '..', './..a', '../a' ]
    },
    {
      src :  _.arrayToMap( [ '', 'a', '.', '.a', './a', '..', '..a', '../a' ] ),
      expected : _.arrayToMap( [ './', './a', '.', './.a', './a', '..', './..a', '../a' ] )
    },
    {
      src : [ 'a', './', '', '/' ],
      error : true
    },
    {
      src : [ 'b', './a', '../a', '/a' ],
      error : true
    },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.pathsDot( c.src ) )
    }
    else
    test.identical( _.pathsDot( c.src ), c.expected );
  }
}

//

function pathUndot( test )
{
  var cases =
  [
    { src : './', expected : '' },
    { src : './a', expected : 'a' },
    { src : 'a', expected : 'a' },
    { src : '.', expected : '.' },
    { src : './.a', expected : '.a' },
    { src : '..', expected : '..' },
    { src : './..a', expected : '..a' },
    { src : '/./a', expected : '/./a' },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.pathUndot( c.src ) )
    }
    else
    test.identical( _.pathUndot( c.src ), c.expected );
  }
}

//

function pathsUndot( test )
{
  test.case = 'rm ./ prefix'
  var cases =
  [
    {
      src : [ './', './a', '.', './.a', './a', '..', './..a', '../a', 'a', '/a' ],
      expected :  [ '', 'a', '.', '.a', 'a', '..', '..a', '../a', 'a', '/a' ]
    },
    {
      src : _.arrayToMap( [ './', './a', '.', './.a', './a', '..', './..a', '../a', 'a', '/a' ] ),
      expected :  _.arrayToMap( [ '', 'a', '.', '.a', 'a', '..', '..a', '../a', 'a', '/a' ] )
    },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.pathsUndot( c.src ) )
    }
    else
    test.identical( _.pathsUndot( c.src ), c.expected );
  }
}

//

function _pathJoinAct( test )
{

  var options1 =
  {
    reroot : 1,
    url : 0,
  },
  options2 =
  {
    reroot : 0,
    url : 1,
  },
  options3 =
  {
    reroot : 0,
    url : 0,
  },

  paths1 = [ 'http://www.site.com:13/', 'bar', 'foo', ],
  paths2 = [ 'c:\\', 'foo\\', 'bar\\' ],
  paths3 = [ '/bar/', '/', 'foo/' ],
  paths4 = [ '/bar/', '/baz', 'foo/' ],

  expected1 = 'http://www.site.com:13/bar/foo',
  expected2 = '/c/foo/bar',
  expected3 = '/foo',
  expected4 = '/bar/baz/foo';

  test.case = 'join url';
  var got = _._pathJoinAct( _.mapSupplement( { paths : paths1 },options2 ) );
  test.identical( got, expected1 );

  test.case = 'join windows os paths';
  var got = _._pathJoinAct( _.mapSupplement( { paths : paths2 },options3 ) );
  test.identical( got, expected2 );

  test.case = 'join unix os paths';
  var got = _._pathJoinAct( _.mapSupplement( { paths : paths3 },options3 ) );
  test.identical( got, expected3 );

  test.case = 'join unix os paths with reroot';
  var got = _._pathJoinAct( _.mapSupplement( { paths : paths4 },options1 ) );
  test.identical( got, expected4 );

  test.case = 'join reroot with /';
  var got = _._pathJoinAct
  ({
    paths : [ '/','/a/b' ],
    reroot : 1,
    url : 0,
  });
  test.identical( got, '/a/b' );

  if( !Config.debug )
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function()
  {
    _._pathJoinAct();
  });

  test.case = 'path element is not string';
  test.shouldThrowErrorSync( function()
  {
    _._pathJoinAct( _.mapSupplement( { paths : [ 34 , 'foo/' ] },options3 ) );
  });

  test.case = 'missed options';
  test.shouldThrowErrorSync( function()
  {
    _._pathJoinAct( paths1 );
  });

  test.case = 'options has unexpected parameters';
  test.shouldThrowErrorSync( function()
  {
    _._pathJoinAct({ paths : paths1, wrongParameter : 1 });
  });

  test.case = 'options does not has paths';
  test.shouldThrowErrorSync( function()
  {
    _._pathJoinAct({ wrongParameter : 1 });
  });
}

//

function pathJoin( test )
{

  // test.case = 'missed arguments';
  // var got = _.pathJoin();
  // test.identical( got, '.' );

  test.case = 'join windows os paths';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar';
  var got = _.pathJoin.apply( _, paths );
  test.identical( got, expected );

  test.case = 'join unix os paths';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo/.';
  var got = _.pathJoin.apply( _, paths );
  test.identical( got, expected );

  test.case = 'more complicated cases'; /* */

  var paths = [  '/aa', 'bb//', 'cc' ];
  var expected = '/aa/bb//cc';
  var got = _.pathJoin.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/aa', '/bb', 'cc' ];
  var expected = '/bb/cc';
  var got = _.pathJoin.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '//aa', 'bb//', 'cc//' ];
  var expected = '//aa/bb//cc//';
  var got = _.pathJoin.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/aa', 'bb//', 'cc','.' ];
  var expected = '/aa/bb//cc/.';
  var got = _.pathJoin.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/','a', '//b//', '././c', '../d', '..e' ];
  var expected = '//b//././c/../d/..e';
  var got = _.pathJoin.apply( _, paths );
  test.identical( got, expected );

  if( !Config.debug ) //
  return;

  test.case = 'nothing passed';
  test.shouldThrowErrorSync( function()
  {
    _.pathJoin();
  });

  test.case = 'non string passed';
  test.shouldThrowErrorSync( function()
  {
    _.pathJoin( {} );
  });

}

//

function pathsJoin( test )
{
  test.case = 'join windows os paths';

  var got = _.pathsJoin( '/a', [ 'c:\\', 'foo\\', 'bar\\' ] );
  var expected = [ '/c', '/a/foo', '/a/bar' ];
  test.identical( got, expected );

  var got = _.pathsJoin( '/a', [ 'c:\\', 'foo\\', 'bar\\' ], 'd' );
  var expected = [ '/c/d', '/a/foo/d', '/a/bar/d' ];
  test.identical( got, expected );

  var got = _.pathsJoin( 'c:\\', [ 'a', 'b', 'c' ], 'd' );
  var expected = [ '/c/a/d', '/c/b/d', '/c/c/d' ];
  test.identical( got, expected );

  var got = _.pathsJoin( 'c:\\', [ '../a', './b', '..c' ] );
  var expected = [ '/c/../a', '/c/./b', '/c/..c' ];
  test.identical( got, expected );

  test.case = 'join unix os paths';

  var got = _.pathsJoin( '/a', [ 'b', 'c' ], 'd', 'e' );
  var expected = [ '/a/b/d/e', '/a/c/d/e' ];
  test.identical( got, expected );

  var got = _.pathsJoin( [ '/a', '/b', '/c' ], 'e' );
  var expected = [ '/a/e', '/b/e', '/c/e' ];
  test.identical( got, expected );

  var got = _.pathsJoin( [ '/a', '/b', '/c' ], [ '../a', '../b', '../c' ], [ './a', './b', './c' ] );
  var expected = [ '/a/../a/./a', '/b/../b/./b', '/c/../c/./c' ];
  test.identical( got, expected );

  var got = _.pathsJoin( [ 'a', 'b', 'c' ], [ 'a1', 'b1', 'c1' ], [ 'a2', 'b2', 'c2' ] );
  var expected = [ 'a/a1/a2', 'b/b1/b2', 'c/c1/c2' ];
  test.identical( got, expected );

  var got = _.pathsJoin( [ '/a', '/b', '/c' ], [ '../a', '../b', '../c' ], [ './a', './b', './c' ] );
  var expected = [ '/a/../a/./a', '/b/../b/./b', '/c/../c/./c' ];
  test.identical( got, expected );

  var got = _.pathsJoin( [ '/', '/a', '//a' ], [ '//', 'a//', 'a//a' ], 'b' );
  var expected = [ '//b', '/a/a//b', '//a/a//a/b' ];
  test.identical( got, expected );

  //

  test.case = 'works like pathJoin'

  var got = _.pathsJoin( '/a' );
  var expected = _.pathJoin( '/a' );
  test.identical( got, expected );

  var got = _.pathsJoin( '/a', 'd', 'e' );
  var expected = _.pathJoin( '/a', 'd', 'e' );
  test.identical( got, expected );

  var got = _.pathsJoin( '/a', '../a', './c' );
  var expected = _.pathJoin( '/a', '../a', './c' );
  test.identical( got, expected );

  //

  test.case = 'scalar + array with single argument'

  var got = _.pathsJoin( '/a', [ 'b' ] );
  var expected = [ '/a/b' ];
  test.identical( got, expected );

  test.case = 'array + array with single arguments'

  var got = _.pathsJoin( [ '/a' ], [ 'b' ] );
  var expected = [ '/a/b' ];
  test.identical( got, expected );

  //

  if( !Config.debug )
  return;

  test.case = 'arrays with different length'
  test.shouldThrowError( function()
  {
    _.pathsJoin( [ '/b', '.c' ], [ '/b' ] );
  });

  test.case = 'nothing passed';
  test.shouldThrowErrorSync( function()
  {
    _.pathsJoin();
  });

  test.case = 'object passed';
  test.shouldThrowErrorSync( function()
  {
    _.pathsJoin( {} );
  });

  test.case = 'inner arrays'
  test.shouldThrowError( function()
  {
    _.pathsJoin( [ '/b', '.c' ], [ '/b', [ 'x' ] ] );
  });
}

//

function pathReroot( test )
{

  // test.case = 'missed arguments';
  // var got = _.pathReroot();
  // test.identical( got, '.' );

  test.case = 'join windows os paths';
  var paths1 = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected1 = '/c/foo/bar';
  var got = _.pathReroot.apply( _, paths1 );
  test.identical( got, expected1 );

  test.case = 'join unix os paths';
  var paths2 = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected2 = '/bar/baz/foo/.';
  var got = _.pathReroot.apply( _, paths2 );
  test.identical( got, expected2 );

  test.case = 'reroot';

  var got = _.pathReroot( 'a', '/a', 'b' );
  var expected = 'a/a/b';
  test.identical( got, expected );

  var got = _.pathReroot( 'a', '/a', '/b' );
  var expected = 'a/a/b';
  test.identical( got, expected );

  var got = _.pathReroot( '/a', '/b', '/c' );
  var expected = '/a/b/c';
  test.identical( got, expected );

  if( !Config.debug )
  return;

  test.case = 'nothing passed';
  test.shouldThrowErrorSync( function()
  {
    _.pathReroot();
  });

  test.case = 'not string passed';
  test.shouldThrowErrorSync( function()
  {
    _.pathReroot( {} );
  });

}

//

function pathsReroot( test )
{

  test.case = 'paths reroot';

  var got = _.pathsReroot( 'a', [ '/a', 'b' ] );
  var expected = [ 'a/a', 'a/b' ];
  test.identical( got, expected );

  var got = _.pathsReroot( [ '/a', '/b' ], [ '/a', '/b' ] );
  var expected = [ '/a/a', '/b/b' ];
  test.identical( got, expected );

  var got = _.pathsReroot( '../a', [ '/b', '.c' ], './d' );
  var expected = [ '../a/b/./d', '../a/.c/./d' ]
  test.identical( got, expected );

  var got = _.pathsReroot( [ '/a' , '/a' ] );
  var expected = [ '/a' , '/a' ];
  test.identical( got, expected );

  var got = _.pathsReroot( '.', '/', './', [ 'a', 'b' ] );
  var expected = [ '././a', '././b' ];
  test.identical( got, expected );

  //

  test.case = 'scalar + scalar'

  var got = _.pathsReroot( '/a', '/a' );
  var expected = '/a/a';
  test.identical( got, expected );

  test.case = 'scalar + array with single argument'

  var got = _.pathsReroot( '/a', [ '/b' ] );
  var expected = [ '/a/b' ];
  test.identical( got, expected );

  test.case = 'array + array with single arguments'

  var got = _.pathsReroot( [ '/a' ], [ '/b' ] );
  var expected = [ '/a/b' ];
  test.identical( got, expected );

  if( !Config.debug )
  return;

  test.case = 'arrays with different length'
  test.shouldThrowError( function()
  {
    _.pathsReroot( [ '/b', '.c' ], [ '/b' ] );
  });

  test.case = 'inner arrays'
  test.shouldThrowError( function()
  {
    _.pathsReroot( [ '/b', '.c' ], [ '/b', [ 'x' ] ] );
  });
}

//

function pathResolve( test )
{

  test.case = 'join windows os paths';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  test.case = 'join unix os paths';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  test.case = 'here cases'; /* */

  var paths = [ 'aa','.','cc' ];
  var expected = _.pathJoin( _.pathCurrent(), 'aa/cc' );
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  'aa','cc','.' ];
  var expected = _.pathJoin( _.pathCurrent(), 'aa/cc' );
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '.','aa','cc' ];
  var expected = _.pathJoin( _.pathCurrent(), 'aa/cc' );
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  test.case = 'down cases'; /* */

  var paths = [  '.','aa','cc','..' ];
  var expected = _.pathJoin( _.pathCurrent(), 'aa' );
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '.','aa','cc','..','..' ];
  var expected = _.pathCurrent();
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  console.log( '_.pathCurrent()',_.pathCurrent() );
  var paths = [  'aa','cc','..','..','..' ];
  var expected = _.strCutOffRight( _.pathCurrent(),'/' )[ 0 ];
  if( _.pathCurrent() === '/' )
  expected = '/..';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  test.case = 'like-down or like-here cases'; /* */

  var paths = [  '.x.','aa','bb','.x.' ];
  var expected = _.pathJoin( _.pathCurrent(), '.x./aa/bb/.x.' );
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '..x..','aa','bb','..x..' ];
  var expected = _.pathJoin( _.pathCurrent(), '..x../aa/bb/..x..' );
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  test.case = 'period and double period combined'; /* */

  var paths = [  '/abc','./../a/b' ];
  var expected = '/a/b';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','a/.././a/b' ];
  var expected = '/abc/a/b';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','.././a/b' ];
  var expected = '/a/b';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./.././a/b' ];
  var expected = '/a/b';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./../.' ];
  var expected = '/';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./../../.' ];
  var expected = '/..';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./../.' ];
  var expected = '/';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  if( !Config.debug ) //
  return;

  test.case = 'nothing passed';
  test.shouldThrowErrorSync( function()
  {
    _.pathResolve();
  });

  test.case = 'non string passed';
  test.shouldThrowErrorSync( function()
  {
    _.pathResolve( {} );
  });
}

//

function pathsResolve( test )
{
  test.case = 'paths resolve';

  var current = _.pathCurrent();

  var got = _.pathsResolve( 'c', [ '/a', 'b' ] );
  var expected = [ '/a', _.pathJoin( current, 'c/b' ) ];
  test.identical( got, expected );

  var got = _.pathsResolve( [ '/a', '/b' ], [ '/a', '/b' ] );
  var expected = [ '/a', '/b' ];
  test.identical( got, expected );

  var got = _.pathsResolve( '../a', [ 'b', '.c' ] );
  var expected = [ _.pathDir( current ) + '/a/b', _.pathDir( current ) + '/a/.c' ]
  test.identical( got, expected );

  var got = _.pathsResolve( '../a', [ '/b', '.c' ], './d' );
  var expected = [ '/b/d', _.pathDir( current ) + '/a/.c/d' ];
  test.identical( got, expected );

  var got = _.pathsResolve( [ '/a', '/a' ],[ 'b', 'c' ] );
  var expected = [ '/a/b' , '/a/c' ];
  test.identical( got, expected );

  var got = _.pathsResolve( [ '/a', '/a' ],[ 'b', 'c' ], 'e' );
  var expected = [ '/a/b/e' , '/a/c/e' ];
  test.identical( got, expected );

  var got = _.pathsResolve( [ '/a', '/a' ],[ 'b', 'c' ], '/e' );
  var expected = [ '/e' , '/e' ];
  test.identical( got, expected );

  var got = _.pathsResolve( '.', '../', './', [ 'a', 'b' ] );
  var expected = [ _.pathDir( current ) + '/a', _.pathDir( current ) + '/b' ];
  test.identical( got, expected );

  //

  test.case = 'works like pathResolve';

  var got = _.pathsResolve( '/a', 'b', 'c' );
  var expected = _.pathResolve( '/a', 'b', 'c' );
  test.identical( got, expected );

  var got = _.pathsResolve( '/a', 'b', 'c' );
  var expected = _.pathResolve( '/a', 'b', 'c' );
  test.identical( got, expected );

  var got = _.pathsResolve( '../a', '.c' );
  var expected = _.pathResolve( '../a', '.c' );
  test.identical( got, expected );

  var got = _.pathsResolve( '/a' );
  var expected = _.pathResolve( '/a' );
  test.identical( got, expected );

  //

  test.case = 'scalar + array with single argument'

  var got = _.pathsResolve( '/a', [ 'b/..' ] );
  var expected = [ '/a' ];
  test.identical( got, expected );

  test.case = 'array + array with single arguments'

  var got = _.pathsResolve( [ '/a' ], [ 'b/../' ] );
  var expected = [ '/a' ];
  test.identical( got, expected );

  //

  if( !Config.debug )
  return

  test.case = 'arrays with different length'
  test.shouldThrowError( function()
  {
    _.pathsResolve( [ '/b', '.c' ], [ '/b' ] );
  });

  test.shouldThrowError( function()
  {
    _.pathsResolve( [ '/a' , '/a' ] );
  });

  test.shouldThrowError( function()
  {
    _.pathsResolve();
  });

  test.case = 'inner arrays'
  test.shouldThrowError( function()
  {
    _.pathsResolve( [ '/b', '.c' ], [ '/b', [ 'x' ] ] );
  });
}

//

function pathDir( test )
{

  test.case = 'simple absolute path'; /* */

  var path2 = '/foo';
  var expected2 = '/';
  var got = _.pathDir( path2 );
  test.identical( got, expected2 );

  test.case = 'absolute path : nested dirs'; /* */

  var path = '/foo/bar/baz/text.txt';
  var expected = '/foo/bar/baz';
  var got = _.pathDir( path );
  test.identical( got, expected );

  var path = '/aa/bb';
  var expected = '/aa';
  var got = _.pathDir( path );
  test.identical( got, expected );

  var path = '/aa/bb/';
  var expected = '/aa';
  var got = _.pathDir( path );
  test.identical( got, expected );

  var path = '/aa';
  var expected = '/';
  var got = _.pathDir( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/..';
  var got = _.pathDir( path );
  test.identical( got, expected );

  test.case = 'relative path : nested dirs'; /* */

  var path = 'aa/bb';
  var expected = 'aa';
  var got = _.pathDir( path );
  test.identical( got, expected );

  var path = 'aa';
  var expected = '.';
  var got = _.pathDir( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '..';
  var got = _.pathDir( path );
  test.identical( got, expected );

  var path = '..';
  var expected = '../..';
  var got = _.pathDir( path );
  test.identical( got, expected );

  // test.case = 'windows os path';
  // var path4 = 'c:/';
  // var expected4 = 'c:/..';
  // var got = _.pathDir( path4 );
  // test.identical( got, expected4 );

  // test.case = 'windows os path : nested dirs';
  // var path5 = 'a:/foo/baz/bar.txt';
  // var expected5 = 'a:/foo/baz';
  // var got = _.pathDir( path5 );
  // test.identical( got, expected5 );

  if( !Config.debug )
  return;

  test.case = 'empty path';
  test.shouldThrowErrorSync( function()
  {
    var got = _.pathDir( '' );
  });

  test.case = 'redundant argument';
  test.shouldThrowErrorSync( function()
  {
    var got = _.pathDir( 'a','b' );
  });

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.pathDir( {} );
  });

}

//

function pathsDir( test )
{
  var cases =
  [
    {
      description : 'simple absolute path',
      src : [ '/foo' ],
      expected : [ '/' ]
    },
    {
      description : 'absolute path : nested dirs',
      src :
      [
        '/foo/bar/baz/text.txt',
        '/aa/bb',
        '/aa/bb/',
        '/aa',
        '/'
      ],
      expected :
      [
        '/foo/bar/baz',
        '/aa',
        '/aa',
        '/',
        '/..'
      ]
    },
    {
      description : 'relative path : nested dirs',
      src :
      [
        'aa/bb',
        'aa',
        '.',
        '..'
      ],
      expected :
      [
        'aa',
        '.',
        '..',
        '../..'
      ]
    },
    {
      description : 'incorrect path type',
      src : [  'aa/bb',  1  ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.pathsDir( c.src ) )
    }
    else
    test.identical( _.pathsDir( c.src ), c.expected );
  }

}

//

function pathsExt( test )
{
  var cases =
  [
    {
      description : 'absolute path : nested dirs',
      src :
      [
        'some.txt',
        '/foo/bar/baz.asdf',
        '/foo/bar/.baz',
        '/foo.coffee.md',
        '/foo/bar/baz'
      ],
      expected :
      [
        'txt',
        'asdf',
        '',
        'md',
        ''
      ]
    },
    {
      description : 'incorrect path type',
      src : [  'aa/bb',  1  ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.pathsExt( c.src ) )
    }
    else
    test.identical( _.pathsExt( c.src ), c.expected );
  }
}

//

function pathExt( test )
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

  test.case = 'empty path';
  var got = _.pathExt( path1 );
  test.identical( got, expected1 );

  test.case = 'txt extension';
  var got = _.pathExt( path2 );
  test.identical( got, expected2 );

  test.case = 'path with non empty dir name';
  var got = _.pathExt( path3 );
  test.identical( got, expected3) ;

  test.case = 'hidden file';
  var got = _.pathExt( path4 );
  test.identical( got, expected4 );

  test.case = 'several extension';
  var got = _.pathExt( path5 );
  test.identical( got, expected5 );

  test.case = 'file without extension';
  var got = _.pathExt( path6 );
  test.identical( got, expected6 );

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.pathExt( null );
  });

}

//

function pathPrefix( test )
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

  test.case = 'empty path';
  var got = _.pathPrefix( path1 );
  test.identical( got, expected1 );

  test.case = 'txt extension';
  var got = _.pathPrefix( path2 );
  test.identical( got, expected2 );

  test.case = 'path with non empty dir name';
  var got = _.pathPrefix( path3 );
  test.identical( got, expected3 ) ;

  test.case = 'hidden file';
  var got = _.pathPrefix( path4 );
  test.identical( got, expected4 );

  test.case = 'several extension';
  var got = _.pathPrefix( path5 );
  test.identical( got, expected5 );

  test.case = 'file without extension';
  var got = _.pathPrefix( path6 );
  test.identical( got, expected6 );

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.pathPrefix( null );
  });
};

//

function pathsPrefix( test )
{
  var cases =
  [
    {
      description : 'get path without ext',
      src :
      [
        '',
        'some.txt',
        '/foo/bar/baz.asdf',
        '/foo/bar/.baz',
        '/foo.coffee.md',
        '/foo/bar/baz'
      ],
      expected :
      [
        '',
        'some',
        '/foo/bar/baz',
        '/foo/bar/',
        '/foo',
        '/foo/bar/baz'
      ]
    },
    {
      description : 'incorrect path type',
      src : [  'aa/bb',  1  ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.pathsPrefix( c.src ) )
    }
    else
    test.identical( _.pathsPrefix( c.src ), c.expected );
  }
}

//

function pathName( test )
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

  test.case = 'empty path';
  var got = _.pathName( path1 );
  test.identical( got, expected1 );

  test.case = 'get file with extension';
  var got = _.pathName({ path : path2, withExtension : 1 } );
  test.identical( got, expected2 );

  test.case = 'got file without extension';
  var got = _.pathName({ path : path3, withExtension : 0 } );
  test.identical( got, expected3) ;

  test.case = 'hidden file';
  var got = _.pathName({ path : path4, withExtension : 1 } );
  test.identical( got, expected4 );

  test.case = 'several extension';
  var got = _.pathName( path5 );
  test.identical( got, expected5 );

  test.case = 'file without extension';
  var got = _.pathName( path6 );
  test.identical( got, expected6 );

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.pathName( false );
  });
};

//

function pathsName( test )
{
  var cases =
  [
    {
      description : 'get paths name',
      withExtension : 0,
      src :
      [
        '',
        'some.txt',
        '/foo/bar/baz.asdf',
        '/foo/bar/.baz',
        '/foo.coffee.md',
        '/foo/bar/baz'
      ],
      expected :
      [
        '',
        'some',
        'baz',
        '',
        'foo.coffee',
        'baz'
      ]
    },
    {
      description : 'get paths name with extension',
      withExtension : 1,
      src :
      [
        '',
        'some.txt',
        '/foo/bar/baz.asdf',
        '/foo/bar/.baz',
        '/foo.coffee.md',
        '/foo/bar/baz'
      ],
      expected :
      [
        '',
        'some.txt',
        'baz.asdf',
        '.baz',
        'foo.coffee.md',
        'baz'
      ]
    },
    {
      description : 'incorrect path type',
      src : [  'aa/bb',  1  ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];

    test.case = c.description;

    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.pathsName( c.src ) );
    }
    else
    {
      var args = c.src.slice();

      if( c.withExtension )
      {
        for( var j = 0; j < args.length; j++ )
        args[ j ] = { path : args[ j ], withExtension : 1 };
      }

      test.identical( _.pathsName( args ), c.expected );
    }
  }
};

//

// function pathCurrent( test )
// {
//   var got, expected;
//
//   test.case = 'get current working dir';
//
//   if( isBrowser )
//   {
//     /*default*/
//
//     got = _.pathCurrent();
//     expected = '.';
//     test.identical( got, expected );
//
//     /*incorrect arguments count*/
//
//     test.shouldThrowErrorSync( function()
//     {
//       _.pathCurrent( 0 );
//     })
//
//   }
//   else
//   {
//     /*default*/
//
//     if( _.fileProvider )
//     {
//
//       got = _.pathCurrent();
//       expected = _.pathNormalize( process.cwd() );
//       test.identical( got,expected );
//
//       /*empty string*/
//
//       expected = _.pathNormalize( process.cwd() );
//       got = _.pathCurrent( '' );
//       test.identical( got,expected );
//
//       /*changing cwd*/
//
//       got = _.pathCurrent( './staging' );
//       expected = _.pathNormalize( process.cwd() );
//       test.identical( got,expected );
//
//       /*try change cwd to terminal file*/
//
//       got = _.pathCurrent( './abase/layer3/aPathTools.s' );
//       expected = _.pathNormalize( process.cwd() );
//       test.identical( got,expected );
//
//     }
//
//     /*incorrect path*/
//
//     test.shouldThrowErrorSync( function()
//     {
//       got = _.pathCurrent( './incorrect_path' );
//       expected = _.pathNormalize( process.cwd() );
//       test.identical( got,expected );
//     });
//
//     if( Config.debug )
//     {
//       /*incorrect arguments length*/
//
//       test.shouldThrowErrorSync( function()
//       {
//         _.pathCurrent( '.', '.' );
//       })
//
//       /*incorrect argument type*/
//
//       test.shouldThrowErrorSync( function()
//       {
//         _.pathCurrent( 123 );
//       })
//     }
//
//   }
//
// }

//

function pathWithoutExt( test )
{

  test.case = 'empty path';
  var path = '';
  var expected = '';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected );

  /* */

  test.case = 'txt extension';
  var path = 'some.txt';
  var expected = 'some';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected );

  /* */

  test.case = 'path with non empty dir name';
  var path = '/foo/bar/baz.asdf';
  var expected = '/foo/bar/baz';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected ) ;

  /* */

  test.case = 'hidden file';
  var path = '/foo/bar/.baz';
  var expected = '/foo/bar/.baz';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected );

  /* */

  test.case = 'file with composite file name';
  var path = '/foo.coffee.md';
  var expected = '/foo.coffee';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected );

  /* */

  test.case = 'path without extension';
  var path = '/foo/bar/baz';
  var expected = '/foo/bar/baz';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected );

  /* */

  test.case = 'relative path #1';
  var got = _.pathWithoutExt( './foo/.baz' );
  var expected = './foo/.baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #2';
  var got = _.pathWithoutExt( './.baz' );
  var expected = './.baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #3';
  var got = _.pathWithoutExt( '.baz.txt' );
  var expected = '.baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #4';
  var got = _.pathWithoutExt( './baz.txt' );
  var expected = './baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #5';
  var got = _.pathWithoutExt( './foo/baz.txt' );
  var expected = './foo/baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #6';
  var got = _.pathWithoutExt( './foo/' );
  var expected = './foo/';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #7';
  var got = _.pathWithoutExt( 'baz' );
  var expected = 'baz';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #8';
  var got = _.pathWithoutExt( 'baz.a.b' );
  var expected = 'baz.a';
  test.identical( got, expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.pathWithoutExt( null );
  });
};

//

function pathsWithoutExt( test )
{

  var cases =
  [
    {
      description : ' get paths without extension ',
      src :
      [
        '',
        'some.txt',
        '/foo/bar/baz.asdf',
        '/foo/bar/.baz',
        '/foo.coffee.md',
        '/foo/bar/baz',
        './foo/.baz',
        './.baz',
        '.baz.txt',
        './baz.txt',
        './foo/baz.txt',
        './foo/',
        'baz',
        'baz.a.b'
      ],
      expected :
      [
        '',
        'some',
        '/foo/bar/baz',
        '/foo/bar/.baz',
        '/foo.coffee',
        '/foo/bar/baz',
        './foo/.baz',
        './.baz',
        '.baz',
        './baz',
        './foo/baz',
        './foo/',
        'baz',
        'baz.a'
      ]
    },
    {
      description : 'incorrect path type',
      src : [  'aa/bb',  1  ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];

    test.case = c.description;

    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.pathsWithoutExt( c.src ) );
    }
    else
    test.identical( _.pathsWithoutExt( c.src ), c.expected );
  }
};

//

function pathChangeExt( test )
{
  test.case = 'empty ext';
  var got = _.pathChangeExt( 'some.txt', '' );
  var expected = 'some';
  test.identical( got, expected );

  /* */

  test.case = 'simple change extension';
  var got = _.pathChangeExt( 'some.txt', 'json' );
  var expected = 'some.json';
  test.identical( got, expected );

  /* */

  test.case = 'path with non empty dir name';
  var got = _.pathChangeExt( '/foo/bar/baz.asdf', 'txt' );
  var expected = '/foo/bar/baz.txt';
  test.identical( got, expected) ;

  /* */

  test.case = 'change extension of hidden file';
  var got = _.pathChangeExt( '/foo/bar/.baz', 'sh' );
  var expected = '/foo/bar/.baz.sh';
  test.identical( got, expected );

  /* */

  test.case = 'change extension in composite file name';
  var got = _.pathChangeExt( '/foo.coffee.md', 'min' );
  var expected = '/foo.coffee.min';
  test.identical( got, expected );

  /* */

  test.case = 'add extension to file without extension';
  var got = _.pathChangeExt( '/foo/bar/baz', 'txt' );
  var expected = '/foo/bar/baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'path folder contains dot, file without extension';
  var got = _.pathChangeExt( '/foo/baz.bar/some.md', 'txt' );
  var expected = '/foo/baz.bar/some.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #1';
  var got = _.pathChangeExt( './foo/.baz', 'txt' );
  var expected = './foo/.baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #2';
  var got = _.pathChangeExt( './.baz', 'txt' );
  var expected = './.baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #3';
  var got = _.pathChangeExt( '.baz', 'txt' );
  var expected = '.baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #4';
  var got = _.pathChangeExt( './baz', 'txt' );
  var expected = './baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #5';
  var got = _.pathChangeExt( './foo/baz', 'txt' );
  var expected = './foo/baz.txt';
  test.identical( got, expected );

  /* */

  test.case = 'relative path #6';
  var got = _.pathChangeExt( './foo/', 'txt' );
  var expected = './foo/.txt';
  test.identical( got, expected );

  /* */

  if( !Config.debug )
  return;

  test.case = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.pathChangeExt( null, '' );
  });

}

//

function pathsChangeExt( test )
{
  var cases =
  [
    {
      description : 'change paths extension ',
      src :
      [
        [ 'some.txt', '' ],
        [ 'some.txt', 'json' ],
        [ '/foo/bar/baz.asdf', 'txt' ],
        [ '/foo/bar/.baz', 'sh' ],
        [ '/foo.coffee.md', 'min' ],
        [ '/foo/bar/baz', 'txt' ],
        [ '/foo/baz.bar/some.md', 'txt' ],
        [ './foo/.baz', 'txt' ],
        [ './.baz', 'txt' ],
        [ '.baz', 'txt' ],
        [ './baz', 'txt' ],
        [ './foo/baz', 'txt' ],
        [ './foo/', 'txt' ]
      ],
      expected :
      [
        'some',
        'some.json',
        '/foo/bar/baz.txt',
        '/foo/bar/.baz.sh',
        '/foo.coffee.min',
        '/foo/bar/baz.txt',
        '/foo/baz.bar/some.txt',
        './foo/.baz.txt',
        './.baz.txt',
        '.baz.txt',
        './baz.txt',
        './foo/baz.txt',
        './foo/.txt'
      ]
    },
    {
      description : 'element must be array',
      src : [  'aa/bb' ],
      error : true
    },
    {
      description : 'element length must be 2',
      src : [ [ 'abc' ] ],
      error : true
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];

    test.case = c.description;

    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.pathsChangeExt( c.src ) );
    }
    else
    test.identical( _.pathsChangeExt( c.src ), c.expected );
  }
};

//

function pathRelative( test )
{
  var got;

  test.case = 'same path'; /* */

  var pathFrom = '/aa/bb/cc';
  var pathTo = '/aa/bb/cc';
  var expected = '.';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  var pathFrom = '/aa/bb/cc';
  var pathTo = '/aa/bb/cc/';
  var expected = '.';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  var pathFrom = '/aa/bb/cc/';
  var pathTo = '/aa/bb/cc';
  var expected = '.';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  var pathFrom = '/aa//bb/cc/';
  var pathTo = '//xx/yy/zz/';
  var expected = '../../../..//xx/yy/zz';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'down path'; /* */

  var pathFrom = '/aa/bb/cc';
  var pathTo = '/aa/bb';
  var expected = '..';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  var pathFrom = '/aa/bb/cc/';
  var pathTo = '/aa/bb';
  var expected = '..';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  var pathFrom = '/aa/bb/cc';
  var pathTo = '/aa/bb/';
  var expected = '..';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  var pathFrom = '/aa//bb/cc/';
  var pathTo = '//xx/yy/';
  var expected = '../../../..//xx/yy';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'relative to same path'; /* */
  var pathFrom = '/foo/bar/baz/asdf/quux';
  var pathTo = '/foo/bar/baz/asdf/quux';
  var expected = '.';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'relative to nested'; /* */
  var pathFrom = '/foo/bar/baz/asdf/quux';
  var pathTo = '/foo/bar/baz/asdf/quux/new1';
  var expected = 'new1';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'relative to parent directory'; /* */
  var pathFrom = '/foo/bar/baz/asdf/quux';
  var pathTo = '/foo/bar/baz/asdf';
  var expected = '..';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );


  test.case = 'absolute pathes'; /* */
  var pathFrom = '/include/dwtools/abase/layer3.test';
  var pathTo = '/include/dwtools/abase/layer3.test/Path.path.test.s';
  var expected = 'Path.path.test.s';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'absolute pathes, pathFrom === pathTo'; /* */
  var pathFrom = '/include/dwtools/abase/layer3.test';
  var pathTo = '/include/dwtools/abase/layer3.test';
  var expected = '.';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'out of relative dir'; /* */
  var pathFrom = '/abc';
  var pathTo = '/a/b/z';
  var expected = '../a/b/z';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'out of relative dir'; /* */
  var pathFrom = '/abc/def';
  var pathTo = '/a/b/z';
  var expected = '../../a/b/z';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'relative root'; /* */
  var pathFrom = '/';
  var pathTo = '/a/b/z';
  var expected = 'a/b/z';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'relative root'; /* */
  var pathFrom = '/';
  var pathTo = '/a';
  var expected = 'a';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'relative root'; /* */
  var pathFrom = '/';
  var pathTo = '/';
  var expected = '.';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'windows disks'; /* */

  var pathFrom = 'd:/';
  var pathTo = 'c:/x/y';
  var expected = '../c/x/y';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'long, not direct'; /* */

  var pathFrom = '/a/b/xx/yy/zz';
  var pathTo = '/a/b/files/x/y/z.txt';
  var expected = '../../../files/x/y/z.txt';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.case = 'both relative, long, not direct, resolving : 0'; /* */

  var pathFrom = 'a/b/xx/yy/zz';
  var pathTo = 'a/b/files/x/y/z.txt';
  var expected = '../../../files/x/y/z.txt';
  debugger;
  var got = _.pathRelative({ relative : pathFrom, path : pathTo, resolving : 0 });
  test.identical( got, expected );

  test.case = 'both relative, long, not direct, resolving : 1'; /* */

  var pathFrom = 'a/b/xx/yy/zz';
  var pathTo = 'a/b/files/x/y/z.txt';
  var expected = '../../../files/x/y/z.txt';
  debugger;
  var got = _.pathRelative({ relative : pathFrom, path : pathTo, resolving : 1 });
  test.identical( got, expected );

  test.case = 'one relative, resolving 1'; /* */
  var current = _.pathCurrent();
  var upStr = '/';

  //

  var pathFrom = 'c:/x/y';
  var pathTo = 'a/b/files/x/y/z.txt';
  var expected = '../../../a/b/files/x/y/z.txt';
  if( current !== upStr )
  expected = '../../..' + _.pathJoin( current, pathTo );
  var got = _.pathRelative({ relative :  pathFrom, path : pathTo, resolving : 1 });
  test.identical( got, expected );

  //

  var pathFrom = 'a/b/files/x/y/z.txt';
  var pathTo = 'c:/x/y';
  var expected = '../../../../../../c/x/y';
  if( current !== upStr )
  {
    var outOfCurrent = _.pathRelative( current, upStr );
    var pathToNormalized = _.pathNormalize( pathTo );

    expected = outOfCurrent + '/../../../../../..' + pathToNormalized;
  }
  var got = _.pathRelative({ relative :  pathFrom, path : pathTo, resolving : 1 });
  test.identical( got, expected );


  test.case = 'one relative, resolving 0'; /* */

  var pathFrom = 'c:/x/y';
  var pathTo = 'a/b/files/x/y/z.txt';
  var expected = '../../../files/x/y/z.txt';
  test.shouldThrowErrorSync( function()
  {
    _.pathRelative({ relative :  pathFrom, path : pathTo, resolving : 0 });
  })

  //

  if( !Config.debug ) //
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.pathRelative( pathFrom );
  } );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.pathRelative( 'pathFrom3', 'pathTo3', 'pathTo4' );
  } );

  test.case = 'second argument is not string or array';
  test.shouldThrowErrorSync( function( )
  {
    _.pathRelative( 'pathFrom3', null );
  } );

};

//

function pathsRelative( test )
{
  var from =
  [
    '/aa/bb/cc',
    '/aa/bb/cc/',
    '/aa/bb/cc',
    '/aa/bb/cc/',
    '/foo/bar/baz/asdf/quux',
    '/foo/bar/baz/asdf/quux',
    '/foo/bar/baz/asdf/quux',
    '/foo/bar/baz/asdf/quux/dir1/dir2',
    '/abc',
    '/abc/def',
    '/',
    '/',
    '/',
    'd:/',
    '/a/b/xx/yy/zz',
  ];
  var to =
  [
    [ '/aa/bb/cc', '/aa/bb/cc/' ],
    [ '/aa/bb/cc', '//aa/bb/cc/' ],
    [ '/aa/bb', '/aa/bb/' ],
    [ '/aa/bb', '//aa/bb/' ],
    '/foo/bar/baz/asdf/quux',
    '/foo/bar/baz/asdf/quux/new1',
    '/foo/bar/baz/asdf',
    [
      '/foo/bar/baz/asdf/quux/dir1/dir2',
      '/foo/bar/baz/asdf/quux/dir1/',
      '/foo/bar/baz/asdf/quux/',
      '/foo/bar/baz/asdf/quux/dir1/dir2/dir3',
    ],
    '/a/b/z',
    '/a/b/z',
    '/a/b/z',
    '/a',
    '/',
    'c:/x/y',
    '/a/b/files/x/y/z.txt',
  ];

  var expected =
  [
    [ '.', '.' ],
    [ '.', '../../..//aa/bb/cc' ],
    [ '..', '..' ],
    [ '..', '../../..//aa/bb' ],
    '.',
    'new1',
    '..',
    [ '.', '..', '../..', 'dir3' ],
    '../a/b/z',
    '../../a/b/z',
    'a/b/z',
    'a',
    '.',
    '../c/x/y',
    '../../../files/x/y/z.txt',
  ];

  var allArrays = [];
  var allObjects = [];
  var allExpected = [];

  for( var i = 0; i < from.length; i++ )
  {
    var relative = from[ i ];
    var path = to[ i ];
    var exp = expected[ i ];

    test.case = 'single pair inside array'
    debugger
    var got = _.pathsRelative( relative, path );
    test.identical( got, exp );

    test.case = 'as single object'
    var o =
    {
      relative : relative,
      path : path
    }
    allObjects.push( o );
    var got = _.pathsRelative( o );
    test.identical( got, exp );
  }

  test.case = 'relative to array of paths'; /* */
  var pathFrom4 = '/foo/bar/baz/asdf/quux/dir1/dir2';
  var pathTo4 =
  [
    '/foo/bar/baz/asdf/quux/dir1/dir2',
    '/foo/bar/baz/asdf/quux/dir1/',
    '/foo/bar/baz/asdf/quux/',
    '/foo/bar/baz/asdf/quux/dir1/dir2/dir3',
  ];
  var expected4 = [ '.', '..', '../..', 'dir3' ];
  var got = _.pathsRelative( pathFrom4, pathTo4);
  test.identical( got, expected4 );

  test.case = 'relative to array of paths, one of pathes is relative, resolving off'; /* */
  var pathFrom4 = '/foo/bar/baz/asdf/quux/dir1/dir2';
  var pathTo4 =
  [
    '/foo/bar/baz/asdf/quux/dir1/dir2',
    '/foo/bar/baz/asdf/quux/dir1/',
    './foo/bar/baz/asdf/quux/',
    '/foo/bar/baz/asdf/quux/dir1/dir2/dir3',
  ];
  test.shouldThrowErrorSync( function()
  {
    debugger;
    _.pathsRelative( pathFrom4, pathTo4 );
  })

  test.case = 'both relative, long, not direct,resolving 1'; /* */
  var pathFrom = 'a/b/xx/yy/zz';
  var pathTo = 'a/b/files/x/y/z.txt';
  var expected = '../../../files/x/y/z.txt';
  var o =
  {
    relative :  pathFrom,
    path : pathTo,
    resolving : 1
  }
  var got = _.pathsRelative( o );
  test.identical( got, expected );

  //

  test.case = 'works like pathRelative';

  var got = _.pathsRelative( '/aa/bb/cc', '/aa/bb/cc' );
  var expected = _.pathRelative( '/aa/bb/cc', '/aa/bb/cc' );
  test.identical( got, expected );

  var got = _.pathsRelative( '/foo/bar/baz/asdf/quux', '/foo/bar/baz/asdf/quux/new1' );
  var expected = _.pathRelative( '/foo/bar/baz/asdf/quux', '/foo/bar/baz/asdf/quux/new1' );
  test.identical( got, expected );

  //

  if( !Config.debug )
  return;

  test.case = 'only relative';
  test.shouldThrowErrorSync( function()
  {
    _.pathsRelative( '/foo/bar/baz/asdf/quux' );
  })

  /**/

  test.shouldThrowErrorSync( function()
  {
    _.pathsRelative
    ({
      relative : '/foo/bar/baz/asdf/quux'
    });
  })

  test.case = 'two relative, long, not direct'; /* */
  var pathFrom = 'a/b/xx/yy/zz';
  var pathTo = 'a/b/files/x/y/z.txt';
  var o =
  {
    relative :  pathFrom,
    path : pathTo,
    resolving : 0
  }
  var expected = '../../../files/x/y/z.txt';
  var got = _.pathsRelative( o );
  test.identical( got, expected );

  test.case = 'relative to array of paths, one of pathes is relative, resolving off'; /* */
  var pathFrom = '/foo/bar/baz/asdf/quux/dir1/dir2';
  var pathTo =
  [
    '/foo/bar/baz/asdf/quux/dir1/dir2',
    '/foo/bar/baz/asdf/quux/dir1/',
    './foo/bar/baz/asdf/quux/',
    '/foo/bar/baz/asdf/quux/dir1/dir2/dir3',
  ];
  test.shouldThrowErrorSync( function()
  {
    debugger;
    _.pathsRelative([ { relative : pathFrom, path : pathTo } ]);
  })

  test.case = 'one relative, resolving 0'; /* */
  var pathFrom = 'c:/x/y';
  var pathTo = 'a/b/files/x/y/z.txt';
  var o =
  {
    relative :  pathFrom,
    path : pathTo,
    resolving : 0
  }
  test.shouldThrowErrorSync( function()
  {
    _.pathsRelative( o );
  })

  test.case = 'different length'; /* */
  test.shouldThrowErrorSync( function()
  {
    _.pathsRelative( [ '/a1/b' ], [ '/a1','/a2' ] );
  })

}

//

/* example to avoid */

function pathIsSafe( test )
{
  var path1 = '/home/user/dir1/dir2',
    path2 = 'C:/foo/baz/bar',
    path3 = '/foo/bar/.hidden',
    path4 = '/foo/./somedir',
    path5 = 'c:/foo/',
    path6 = 'c:\\foo\\',
    path7 = '/',
    path8 = '/a',
    got;

  test.case = 'safe posix path';
  var got = _.pathIsSafe( path1 );
  test.identical( got, true );

  test.case = 'safe windows path';
  var got = _.pathIsSafe( path2 );
  test.identical( got, true );

  // test.case = 'unsafe posix path ( hidden )';
  // var got = _.pathIsSafe( path3 );
  // test.identical( got, false );

  test.case = 'safe posix path with "." segment';
  var got = _.pathIsSafe( path4 );
  test.identical( got, true );

  test.case = 'unsafe windows path';
  var got = _.pathIsSafe( path5 );
  test.identical( got, false );

  test.case = 'unsafe windows path';
  var got = _.pathIsSafe( path6 );
  test.identical( got, false );

  test.case = 'unsafe short path';
  var got = _.pathIsSafe( path7 );
  test.identical( got, false );

  test.case = 'unsafe short path';
  var got = _.pathIsSafe( path8 );
  test.identical( got, false );

  if( !Config.debug )
  return;

  test.case = 'missed arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.pathIsSafe( );
  });

  test.case = 'argument is not string';
  test.shouldThrowErrorSync( function( )
  {
    _.pathIsSafe( null );
  });

  test.case = 'too macny arguments';
  test.shouldThrowErrorSync( function( )
  {
    _.pathIsSafe( '/a/b','/a/b' );
  });

}

//

function pathIsGlob( test )
{

  test.case = 'this is not glob';

  test.is( !_.pathIsGlob( '!a.js' ) );
  test.is( !_.pathIsGlob( '^a.js' ) );
  test.is( !_.pathIsGlob( '+a.js' ) );
  test.is( !_.pathIsGlob( '!' ) );
  test.is( !_.pathIsGlob( '^' ) );
  test.is( !_.pathIsGlob( '+' ) );

  /**/

  test.case = 'this is glob';

  test.is( _.pathIsGlob( '?' ) );
  test.is( _.pathIsGlob( '*' ) );
  test.is( _.pathIsGlob( '**' ) );

  test.is( _.pathIsGlob( '?c.js' ) );
  test.is( _.pathIsGlob( '*.js' ) );
  test.is( _.pathIsGlob( '**/a.js' ) );

  test.is( _.pathIsGlob( 'dir?c/a.js' ) );
  test.is( _.pathIsGlob( 'dir/*.js' ) );
  test.is( _.pathIsGlob( 'dir/**.js' ) );
  test.is( _.pathIsGlob( 'dir/**/a.js' ) );

  test.is( _.pathIsGlob( '/dir?c/a.js' ) );
  test.is( _.pathIsGlob( '/dir/*.js' ) );
  test.is( _.pathIsGlob( '/dir/**.js' ) );
  test.is( _.pathIsGlob( '/dir/**/a.js' ) );

  test.is( _.pathIsGlob( '[a-c]' ) );
  test.is( _.pathIsGlob( '{a,c}' ) );
  test.is( _.pathIsGlob( '(a|b)' ) );

  test.is( _.pathIsGlob( '(ab)' ) );
  test.is( _.pathIsGlob( '@(ab)' ) );
  test.is( _.pathIsGlob( '!(ab)' ) );
  test.is( _.pathIsGlob( '?(ab)' ) );
  test.is( _.pathIsGlob( '*(ab)' ) );
  test.is( _.pathIsGlob( '+(ab)' ) );

  test.is( _.pathIsGlob( 'dir/[a-c].js' ) );
  test.is( _.pathIsGlob( 'dir/{a,c}.js' ) );
  test.is( _.pathIsGlob( 'dir/(a|b).js' ) );

  test.is( _.pathIsGlob( 'dir/(ab).js' ) );
  test.is( _.pathIsGlob( 'dir/@(ab).js' ) );
  test.is( _.pathIsGlob( 'dir/!(ab).js' ) );
  test.is( _.pathIsGlob( 'dir/?(ab).js' ) );
  test.is( _.pathIsGlob( 'dir/*(ab).js' ) );
  test.is( _.pathIsGlob( 'dir/+(ab).js' ) );

  test.is( _.pathIsGlob( '/index/**' ) );

}

//

function pathCommon( test )
{
  test.case = 'absolute-absolute'

  var got = _.pathCommon([ '/a1/b2', '/a1/b' ]);
  test.identical( got, '/a1' );

  var got = _.pathCommon([ '/a1/b2', '/a1/b1' ]);
  test.identical( got, '/a1' );

  var got = _.pathCommon([ '/a1/x/../b1', '/a1/b1' ]);
  test.identical( got, '/a1/b1' );

  var got = _.pathCommon([ '/a1/b1/c1', '/a1/b1/c' ]);
  test.identical( got, '/a1/b1' );

  var got = _.pathCommon([ '/a1/../../b1/c1', '/a1/b1/c1' ]);
  test.identical( got, '/' );

  var got = _.pathCommon([ '/abcd', '/ab' ]);
  test.identical( got, '/' );

  var got = _.pathCommon([ '/.a./.b./.c.', '/.a./.b./.c' ]);
  test.identical( got, '/.a./.b.' );

  var got = _.pathCommon([ '//a//b//c', '/a/b' ]);
  test.identical( got, '/' );

  var got = _.pathCommon([ '/a//b', '/a//b' ]);
  test.identical( got, '/a' );

  var got = _.pathCommon([ '/a//', '/a//' ]);
  test.identical( got, '/a' );

  var got = _.pathCommon([ '/./a/./b/./c', '/a/b' ]);
  test.identical( got, '/a/b' );

  var got = _.pathCommon([ '/A/b/c', '/a/b/c' ]);
  test.identical( got, '/' );

  var got = _.pathCommon([ '/', '/x' ]);
  test.identical( got, '/' );

  var got = _.pathCommon([ '/a', '/x'  ]);
  test.identical( got, '/' );

  test.case = 'absolute-relative'

  var got = _.pathCommon([ '/', '..' ]);
  test.identical( got, '/' );

  var got = _.pathCommon([ '/', '.' ]);
  test.identical( got, '/' );

  var got = _.pathCommon([ '/', 'x' ]);
  test.identical( got, '/' );

  var got = _.pathCommon([ '/', '../..' ]);
  test.identical( got, '/' );

  test.shouldThrowError( () => _.pathCommon([ '/a', '..' ]) );

  test.shouldThrowError( () => _.pathCommon([ '/a', '.' ]) );

  test.shouldThrowError( () => _.pathCommon([ '/a', 'x' ]) );

  test.shouldThrowError( () => _.pathCommon([ '/a', '../..' ]) );

  test.case = 'relative-relative'

  var got = _.pathCommon([ 'a1/b2', 'a1/b' ]);
  test.identical( got, 'a1' );

  var got = _.pathCommon([ 'a1/b2', 'a1/b1' ]);
  test.identical( got, 'a1' );

  var got = _.pathCommon([ 'a1/x/../b1', 'a1/b1' ]);
  test.identical( got, 'a1/b1' );

  var got = _.pathCommon([ './a1/x/../b1', 'a1/b1' ]);
  test.identical( got,'a1/b1' );

  var got = _.pathCommon([ './a1/x/../b1', './a1/b1' ]);
  test.identical( got, 'a1/b1');

  var got = _.pathCommon([ './a1/x/../b1', '../a1/b1' ]);
  test.identical( got, '..');

  var got = _.pathCommon([ '.', '..' ]);
  test.identical( got, '..' );

  var got = _.pathCommon([ './b/c', './x' ]);
  test.identical( got, '.' );

  var got = _.pathCommon([ './././a', './a/b' ]);
  test.identical( got, 'a' );

  var got = _.pathCommon([ './a/./b', './a/b' ]);
  test.identical( got, 'a/b' );

  var got = _.pathCommon([ './a/./b', './a/c/../b' ]);
  test.identical( got, 'a/b' );

  var got = _.pathCommon([ '../b/c', './x' ]);
  test.identical( got, '..' );

  var got = _.pathCommon([ '../../b/c', '../b' ]);
  test.identical( got, '../..' );

  var got = _.pathCommon([ '../../b/c', '../../../x' ]);
  test.identical( got, '../../..' );

  var got = _.pathCommon([ '../../b/c/../../x', '../../../x' ]);
  test.identical( got, '../../..' );

  var got = _.pathCommon([ './../../b/c/../../x', './../../../x' ]);
  test.identical( got, '../../..' );

  var got = _.pathCommon([ '../../..', './../../..' ]);
  test.identical( got, '../../..' );

  var got = _.pathCommon([ './../../..', './../../..' ]);
  test.identical( got, '../../..' );

  var got = _.pathCommon([ '../../..', '../../..' ]);
  test.identical( got, '../../..' );

  var got = _.pathCommon([ '../b', '../b' ]);
  test.identical( got, '../b' );

  var got = _.pathCommon([ '../b', './../b' ]);
  test.identical( got, '../b' );

  test.case = 'several absolute paths'

  var got = _.pathCommon([ '/a/b/c', '/a/b/c', '/a/b/c' ]);
  test.identical( got, '/a/b/c' );

  var got = _.pathCommon([ '/a/b/c', '/a/b/c', '/a/b' ]);
  test.identical( got, '/a/b' );

  var got = _.pathCommon([ '/a/b/c', '/a/b/c', '/a/b1' ]);
  test.identical( got, '/a' );

  var got = _.pathCommon([ '/a/b/c', '/a/b/c', '/a' ]);
  test.identical( got, '/a' );

  var got = _.pathCommon([ '/a/b/c', '/a/b/c', '/x' ]);
  test.identical( got, '/' );

  var got = _.pathCommon([ '/a/b/c', '/a/b/c', '/' ]);
  test.identical( got, '/' );

  test.shouldThrowError( () => _.pathCommon([ '/a/b/c', '/a/b/c', './' ]) );

  test.shouldThrowError( () => _.pathCommon([ '/a/b/c', '/a/b/c', '.' ]) );

  test.shouldThrowError( () => _.pathCommon([ 'x', '/a/b/c', '/a' ]) );

  test.shouldThrowError( () => _.pathCommon([ '/a/b/c', '..', '/a' ]) );

  test.shouldThrowError( () => _.pathCommon([ '../..', '../../b/c', '/a' ]) );

  test.case = 'several relative paths';

  var got = _.pathCommon([ 'a/b/c', 'a/b/c', 'a/b/c' ]);
  test.identical( got, 'a/b/c' );

  var got = _.pathCommon([ 'a/b/c', 'a/b/c', 'a/b' ]);
  test.identical( got, 'a/b' );

  var got = _.pathCommon([ 'a/b/c', 'a/b/c', 'a/b1' ]);
  test.identical( got, 'a' );

  var got = _.pathCommon([ 'a/b/c', 'a/b/c', '.' ]);
  test.identical( got, '.' );

  var got = _.pathCommon([ 'a/b/c', 'a/b/c', 'x' ]);
  test.identical( got, '.' );

  var got = _.pathCommon([ 'a/b/c', 'a/b/c', './' ]);
  test.identical( got, '.' );

  var got = _.pathCommon([ '../a/b/c', 'a/../b/c', 'a/b/../c' ]);
  test.identical( got, '..' );

  var got = _.pathCommon([ './a/b/c', '../../a/b/c', '../../../a/b' ]);
  test.identical( got, '../../..' );

  var got = _.pathCommon([ '.', './', '..' ]);
  test.identical( got, '..' );

  var got = _.pathCommon([ '.', './../..', '..' ]);
  test.identical( got, '../..' );

}

//

function pathsCommon( test )
{
  var cases =
  [
    {
      description : 'simple',
      src : [ '/a1/b2', '/a1/b' , '/a1/b2/c' ],
      expected : '/a1'
    },
    {
      description : 'with array',
      src : [ '/a1/b2', [ '/a1/b' , '/a1/b2/c' ] ],
      expected : [ '/a1' , '/a1/b2' ]
    },
    {
      description : 'two arrays',
      src : [ [ '/a1/b' , '/a1/b2/c' ], [ '/a1/b' , '/a1/b2/c' ] ],
      expected : [ '/a1/b' , '/a1/b2/c' ]
    },
    {
      description : 'mixed',
      src : [ '/a1', [ '/a1/b' , '/a1/b2/c' ], [ '/a1/b1' , '/a1/b2/c' ], '/a1' ],
      expected : [ '/a1' , '/a1' ]
    },
    {
      description : 'arrays with different length',
      src : [ [ '/a1/b' , '/a1/b2/c' ], [ '/a1/b1'  ] ],
      error : true
    },
    {
      description : 'incorrect argument',
      src : 'abc',
      error : true
    },
    {
      description : 'incorrect arguments length',
      src : [ 'abc', 'x' ],
      error : true
    },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    test.case = c.description;
    if( c.error )
    {
      if( !Config.debug )
      continue;
      test.shouldThrowError( () => _.pathsCommon.apply( _, c.src ) );
    }
    else
    test.identical( _.pathsCommon( c.src ), c.expected );
  }

}

// --
// define class
// --

var Self =
{

  name : 'Tools/base/layer3/path/Path',
  silencing : 1,
  // verbosity : 7,
  // routine : 'pathRelative',

  tests :
  {

    pathRefine : pathRefine,
    pathsRefine : pathsRefine,
    pathIsRefined : pathIsRefined,
    pathNormalize : pathNormalize,
    pathsNormalize : pathsNormalize,
    pathNormalizeTolerant : pathNormalizeTolerant,

    pathDot : pathDot,
    pathsDot : pathsDot,

    pathUndot : pathUndot,
    pathsUndot : pathsUndot,

    _pathJoinAct : _pathJoinAct,
    pathJoin : pathJoin,
    pathsJoin : pathsJoin,
    pathReroot : pathReroot,
    pathsReroot : pathsReroot,
    pathResolve : pathResolve,
    pathsResolve : pathsResolve,

    pathDir : pathDir,
    pathsDir : pathsDir,
    pathExt : pathExt,
    pathsExt : pathsExt,
    pathPrefix : pathPrefix,
    pathsPrefix : pathsPrefix,
    pathName : pathName,
    pathsName : pathsName,
    /*pathCurrent : pathCurrent,*/
    pathWithoutExt : pathWithoutExt,
    pathsWithoutExt : pathsWithoutExt,
    pathChangeExt : pathChangeExt,
    pathsChangeExt : pathsChangeExt,

    pathRelative : pathRelative,
    pathsRelative : pathsRelative,
    pathIsSafe : pathIsSafe,
    pathIsGlob : pathIsGlob,

    pathCommon : pathCommon,
    pathsCommon : pathsCommon

  },

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

if( 0 )
if( typeof module === 'undefined' )
_.timeReady( function()
{

  _.Tester.verbosity = 99;
  _.Tester.logger = wPrinterToJs({ coloring : 1, writingToHtml : 1 });
  _.Tester.test( Self.name,'PathUrlTest' )
  .doThen( function()
  {
    var book = _.Tester.loggerToBook();
  });

});

})();
