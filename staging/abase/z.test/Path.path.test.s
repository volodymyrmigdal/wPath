( function _Path_path_test_s_( ) {

'use strict';

var isBrowser = true;

if( typeof module !== 'undefined' )
{
  isBrowser = false;

  //if( typeof wBase === 'undefined' )
  try
  {
    require( '../../abase/wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  require( '../component/Path.s' );

  _.include( 'wTesting' );
  _.include( 'wFiles' );

}

var _ = wTools;

//

function pathRefine( test )
{

  var got;

  test.description = 'posix path'; //

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar/baz/asdf/quux/..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar/baz/asdf/quux/..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '/foo/bar/baz/asdf/quux/..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar/baz/asdf/quux/../.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  test.description = 'winoows path'; //

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp/foo/bar/..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/bar/..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo/bar/..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp/foo/bar/../..';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp/foo/bar/../../.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  test.description = 'empty path'; //

  var path = '';
  var expected = '.';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '/';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '/';
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

  test.description = 'path with "." in the middle'; //

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

  test.description = 'path with "." in the beginning'; //

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = '././foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = '././foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '/././foo/bar';
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

  test.description = 'path with "." in the end'; //

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

  test.description = 'path with ".." in the middle'; //

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

  test.description = 'path with ".." in the beginning'; //

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '../../foo/bar';
  var got = _.pathRefine( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/../../foo/bar';
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

  test.description = 'path with ".." in the end'; //

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

  // debugger;
  // var con = wConsequence().give();
  // _.timeOut( 5000,function(){ con.give(); } );
  // // test.mustNotThrowError( con );
  // test.shouldMessageOnlyOnce( con );
  // return wConsequence(); // xxx

}

//

function pathIsRefined( test )
{
  test.description = 'posix path, not refined'; //

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  test.description = 'posix path, refined'; //

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

  test.description = 'winoows path, not refined'; //

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

  test.description = 'winoows path, refined'; //

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

  test.description = 'empty path,not refined';

  var path = '';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '/';
  var expected = true;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '//';
  var expected = false;
  var got = _.pathIsRefined( path );
  test.identical( got, expected );

  var path = '///';
  var expected = false;
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

  test.description = 'empty path,refined';

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

  test.description = 'path with "." in the middle'; //

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

  test.description = 'path with "." in the middle,refined';

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

  test.description = 'path with ".." in the middle'; //

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

  test.description = 'path with ".." in the middle,refined'; //

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

  test.description = 'path with ".." in the beginning'; //

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

  test.description = 'path with ".." in the beginning,refined';

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

function pathRegularize( test )
{

  var got;

  test.description = 'posix path'; //

  var path = '/foo/bar//baz/asdf/quux/..';
  var expected = '/foo/bar/baz/asdf';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/foo/bar//baz/asdf/quux/../';
  var expected = '/foo/bar/baz/asdf';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '//foo/bar//baz/asdf/quux/..//';
  var expected = '/foo/bar/baz/asdf';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/bar//baz/asdf/quux/..//.';
  var expected = 'foo/bar/baz/asdf';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  test.description = 'winoows path'; //

  var path = 'C:\\temp\\\\foo\\bar\\..\\';
  var expected = '/C/temp/foo';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\\\';
  var expected = '/C/temp/foo';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\';
  var expected = '/C/temp';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'C:\\temp\\\\foo\\bar\\..\\..\\.';
  var expected = '/C/temp';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  test.description = 'empty path'; //

  var path = '';
  var expected = '.';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/';
  var expected = '/';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '//';
  var expected = '/';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '///';
  var expected = '/';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/.';
  var expected = '/';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/./.';
  var expected = '/';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '.';
  var expected = '.';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = './.';
  var expected = '.';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  test.description = 'path with "." in the middle'; //

  var path = 'foo/./bar/baz';
  var expected = 'foo/bar/baz';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/baz/';
  var expected = 'foo/bar/baz';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/././bar/././baz/';
  var expected = 'foo/bar/baz';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/foo/././bar/././baz/';
  var expected = '/foo/bar/baz';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/foo/.x./baz/';
  var expected = '/foo/.x./baz';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  test.description = 'path with "." in the beginning'; //

  var path = './foo/bar';
  var expected = './foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '././foo/bar/';
  var expected = './foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = './/.//foo/bar/';
  var expected = './foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/.//.//foo/bar/';
  var expected = '/foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '.x/foo/bar';
  var expected = '.x/foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '.x./foo/bar';
  var expected = '.x./foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = './x/.';
  var expected = './x';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  test.description = 'path with "." in the end'; //

  var path = 'foo/bar.';
  var expected = 'foo/bar.';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/.bar.';
  var expected = 'foo/.bar.';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/bar/.';
  var expected = 'foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/bar/./.';
  var expected = 'foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/bar/././';
  var expected = 'foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/foo/bar/././';
  var expected = '/foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/foo/baz/.x./';
  var expected = '/foo/baz/.x.';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  test.description = 'path with ".." in the middle'; //

  var path = 'foo/../bar/baz';
  var expected = 'bar/baz';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/baz/';
  var expected = '../bar/baz';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/../../bar/../../baz/';
  var expected = '../../baz';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/foo/../../bar/../../baz/';
  var expected = '/../../baz';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  test.description = 'path with ".." in the beginning'; //

  var path = '../foo/bar';
  var expected = '../foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '../../foo/bar/';
  var expected = '../../foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '..//..//foo/bar/';
  var expected = '../../foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/..//..//foo/bar/';
  var expected = '/../../foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '..x/foo/bar';
  var expected = '..x/foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '..x../foo/bar';
  var expected = '..x../foo/bar';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  test.description = 'path with ".." in the end'; //

  var path = 'foo/bar..';
  var expected = 'foo/bar..';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/..bar..';
  var expected = 'foo/..bar..';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/bar/..';
  var expected = 'foo';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../..';
  var expected = '.';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../';
  var expected = '.';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/foo/bar/../../';
  var expected = '/';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../..';
  var expected = '..';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/bar/../../../..';
  var expected = '../..';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = 'foo/../bar/../../../..';
  var expected = '../../..';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  test.description = 'path with ".." and "." combined'; //

  var path = '/abc/./../a/b';
  var expected = '/a/b';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/abc/.././a/b';
  var expected = '/a/b';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/abc/./.././a/b';
  var expected = '/a/b';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/../.';
  var expected = '/a/b';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./..';
  var expected = '/a/b';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '/a/b/abc/./../.';
  var expected = '/a/b';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = './../.';
  var expected = '..';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = './..';
  var expected = '..';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

  var path = '../.';
  var expected = '..';
  var got = _.pathRegularize( path );
  test.identical( got, expected );

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

  test.description = 'join url';
  var got = _._pathJoinAct( _.mapSupplement( { paths : paths1 },options2 ) );
  test.identical( got, expected1 );

  test.description = 'join windows os paths';
  var got = _._pathJoinAct( _.mapSupplement( { paths : paths2 },options3 ) );
  test.identical( got, expected2 );

  test.description = 'join unix os paths';
  var got = _._pathJoinAct( _.mapSupplement( { paths : paths3 },options3 ) );
  test.identical( got, expected3 );

  test.description = 'join unix os paths with reroot';
  var got = _._pathJoinAct( _.mapSupplement( { paths : paths4 },options1 ) );
  test.identical( got, expected4 );

  test.description = 'join reroot with /';
  var got = _._pathJoinAct
  ({
    paths : [ '/','/a/b' ],
    reroot : 1,
    url : 0,
  });
  test.identical( got, '/a/b' );

  if( Config.debug )
  {

    test.description = 'missed arguments';
    test.shouldThrowErrorSync( function()
    {
      _._pathJoinAct();
    });

    test.description = 'path element is not string';
    test.shouldThrowErrorSync( function()
    {
      _._pathJoinAct( _.mapSupplement( { paths : [ 34 , 'foo/' ] },options3 ) );
    });

    test.description = 'missed options';
    test.shouldThrowErrorSync( function()
    {
      _._pathJoinAct( paths1 );
    });

    test.description = 'options has unexpected parameters';
    test.shouldThrowErrorSync( function()
    {
      _._pathJoinAct({ paths : paths1, wrongParameter : 1 });
    });

    test.description = 'options does not has paths';
    test.shouldThrowErrorSync( function()
    {
      _._pathJoinAct({ wrongParameter : 1 });
    });

  }


}

//

function pathJoin( test )
{

  // test.description = 'missed arguments';
  // var got = _.pathJoin();
  // test.identical( got, '.' );

  test.description = 'join windows os paths';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar';
  var got = _.pathJoin.apply( _, paths );
  test.identical( got, expected );

  test.description = 'join unix os paths';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo/.';
  var got = _.pathJoin.apply( _, paths );
  test.identical( got, expected );

  test.description = 'more complicated cases'; //

  var paths = [  '/aa', 'bb//', 'cc' ];
  var expected = '/aa/bb/cc';
  var got = _.pathJoin.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/aa', 'bb//', 'cc','.' ];
  var expected = '/aa/bb/cc/.';
  var got = _.pathJoin.apply( _, paths );
  test.identical( got, expected );

  if( Config.debug ) //
  {

    test.description = 'nothing passed';
    test.shouldThrowErrorSync( function()
    {
      _.pathJoin();
    });

    test.description = 'non string passed';
    test.shouldThrowErrorSync( function()
    {
      _.pathJoin( {} );
    });

  }

}

//

function pathReroot( test )
{

  // test.description = 'missed arguments';
  // var got = _.pathReroot();
  // test.identical( got, '.' );

  test.description = 'join windows os paths';
  var paths1 = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected1 = '/c/foo/bar';
  var got = _.pathReroot.apply( _, paths1 );
  test.identical( got, expected1 );

  test.description = 'join unix os paths';
  var paths2 = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected2 = '/bar/baz/foo/.';
  var got = _.pathReroot.apply( _, paths2 );
  test.identical( got, expected2 );

  if( Config.debug )
  {

    test.description = 'nothing passed';
    test.shouldThrowErrorSync( function()
    {
      _.pathJoin();
    });

    test.description = 'not string passed';
    test.shouldThrowErrorSync( function()
    {
      _.pathReroot( {} );
    });
  }

}

//

function pathResolve( test )
{

  test.description = 'join windows os paths';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  test.description = 'join unix os paths';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  test.description = 'here cases'; //

  var paths = [  'aa','.','cc' ];
  var expected = _.pathCurrent() + '/aa/cc';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  'aa','cc','.' ];
  var expected = _.pathCurrent() + '/aa/cc';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '.','aa','cc' ];
  var expected = _.pathCurrent() + '/aa/cc';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  test.description = 'down cases'; //

  var paths = [  '.','aa','cc','..' ];
  var expected = _.pathCurrent() + '/aa';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '.','aa','cc','..','..' ];
  var expected = _.pathCurrent() + '';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  'aa','cc','..','..','..' ]; debugger;
  var expected = _.strCutOffRight( _.pathCurrent(),'/' )[ 0 ]; debugger;
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  test.description = 'like-down or like-here cases'; //

  var paths = [  '.x.','aa','bb','.x.' ];
  var expected = _.pathCurrent() + '/.x./aa/bb/.x.';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '..x..','aa','bb','..x..' ];
  var expected = _.pathCurrent() + '/..x../aa/bb/..x..';
  var got = _.pathResolve.apply( _, paths );
  test.identical( got, expected );

  test.description = 'period and double period combined'; //

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

  if( Config.debug ) //
  {

    test.description = 'nothing passed';
    test.shouldThrowErrorSync( function()
    {
      _.pathResolve();
    });

    test.description = 'non string passed';
    test.shouldThrowErrorSync( function()
    {
      _.pathResolve( {} );
    });

  }

}

//

// function pathResolve( test )
// {
//   var paths1 = [ '/foo', 'bar/', 'baz' ],
//     expected1 = '/foo/bar/baz',
//
//     paths2 = [ '/foo', '/bar/', 'baz' ],
//     expected2 = '/bar/baz',
//
//     path3 = '/foo/bar/baz/asdf/quux',
//     expected3 = '/foo/bar/baz/asdf/quux',
//     got;
//
//   test.description = 'several part of path';
//   var got = _.pathResolve.apply( _, paths1 );
//   test.identical( got, expected1 );
//
//   test.description = 'with root';
//   var got = _.pathResolve.apply( _, paths2 );
//   test.identical( got, expected2 );
//
//   test.description = 'one absolute path';
//   var got = _.pathResolve( path3 );
//   test.identical( got, expected3 );
// };

//

function pathDir( test )
{

  test.description = 'simple absolute path'; //

  var path2 = '/foo';
  var expected2 = '/';
  var got = _.pathDir( path2 );
  test.identical( got, expected2 );

  test.description = 'absolute path : nested dirs'; //

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

  test.description = 'relative path : nested dirs'; //

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

  // test.description = 'windows os path';
  // var path4 = 'c:/';
  // var expected4 = 'c:/..';
  // var got = _.pathDir( path4 );
  // test.identical( got, expected4 );

  // test.description = 'windows os path : nested dirs';
  // var path5 = 'a:/foo/baz/bar.txt';
  // var expected5 = 'a:/foo/baz';
  // var got = _.pathDir( path5 );
  // test.identical( got, expected5 );

  if( Config.debug )
  {

    test.description = 'empty path';
    test.shouldThrowErrorSync( function()
    {
      var got = _.pathDir( '' );
    });

    test.description = 'redundant argument';
    test.shouldThrowErrorSync( function()
    {
      var got = _.pathDir( 'a','b' );
    });

    test.description = 'passed argument is non string';
    test.shouldThrowErrorSync( function()
    {
      _.pathDir( {} );
    });

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
    test.shouldThrowErrorSync( function()
    {
      _.pathExt( null );
    });
  }

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
    test.shouldThrowErrorSync( function()
    {
      _.pathPrefix( null );
    });
  }
};

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

  test.description = 'empty path';
  var got = _.pathName( path1 );
  test.identical( got, expected1 );

  test.description = 'get file with extension';
  var got = _.pathName({ path : path2, withExtension : 1 } );
  test.identical( got, expected2 );

  test.description = 'got file without extension';
  var got = _.pathName({ path : path3, withExtension : 0 } );
  test.identical( got, expected3) ;

  test.description = 'hidden file';
  var got = _.pathName({ path : path4, withExtension : 1 } );
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
    test.shouldThrowErrorSync( function()
    {
      _.pathName( false );
    });
  }
};

//

function pathCurrent( test )
{
  var got, expected;

  test.description = 'get current working dir';

  if( isBrowser )
  {
    /*default*/

    got = _.pathCurrent();
    expected = '.';
    test.identical( got, expected );

    /*incorrect arguments count*/

    test.shouldThrowErrorSync( function()
    {
      _.pathCurrent( 0 );
    })

  }
  else
  {
    /*default*/

    if( _.fileProvider )
    {

      got = _.pathCurrent();
      expected = _.pathRegularize( process.cwd() );
      test.identical( got,expected );

      /*empty string*/

      expected = _.pathRegularize( process.cwd() );
      got = _.pathCurrent( '' );
      test.identical( got,expected );

      /*changing cwd*/

      got = _.pathCurrent( './staging' );
      expected = _.pathRegularize( process.cwd() );
      test.identical( got,expected );

      /*try change cwd to terminal file*/

      got = _.pathCurrent( './abase/component/Path.s' );
      expected = _.pathRegularize( process.cwd() );
      test.identical( got,expected );

    }

    /*incorrect path*/

    test.shouldThrowErrorSync( function()
    {
      got = _.pathCurrent( './incorrect_path' );
      expected = _.pathRegularize( process.cwd() );
      test.identical( got,expected );
    });

    if( Config.debug )
    {
      /*incorrect arguments length*/

      test.shouldThrowErrorSync( function()
      {
        _.pathCurrent( '.', '.' );
      })

      /*incorrect argument type*/

      test.shouldThrowErrorSync( function()
      {
        _.pathCurrent( 123 );
      })
    }

  }

}

//

function pathWithoutExt( test )
{

  test.description = 'empty path';
  var path = '';
  var expected = '';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected );

  //

  test.description = 'txt extension';
  var path = 'some.txt';
  var expected = 'some';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected );

  //

  test.description = 'path with non empty dir name';
  var path = '/foo/bar/baz.asdf';
  var expected = '/foo/bar/baz';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected ) ;

  //

  test.description = 'hidden file';
  var path = '/foo/bar/.baz';
  var expected = '/foo/bar/.baz';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected );

  //

  test.description = 'file with composite file name';
  var path = '/foo.coffee.md';
  var expected = '/foo.coffee';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected );

  //

  test.description = 'path without extension';
  var path = '/foo/bar/baz';
  var expected = '/foo/bar/baz';
  var got = _.pathWithoutExt( path );
  test.identical( got, expected );

  //

  test.description = 'relative path #1';
  var got = _.pathWithoutExt( './foo/.baz' );
  var expected = './foo/.baz';
  test.identical( got, expected );

  //

  test.description = 'relative path #2';
  var got = _.pathWithoutExt( './.baz' );
  var expected = './.baz';
  test.identical( got, expected );

  //

  test.description = 'relative path #3';
  var got = _.pathWithoutExt( '.baz.txt' );
  var expected = '.baz';
  test.identical( got, expected );

  //

  test.description = 'relative path #4';
  var got = _.pathWithoutExt( './baz.txt' );
  var expected = './baz';
  test.identical( got, expected );

  //

  test.description = 'relative path #5';
  var got = _.pathWithoutExt( './foo/baz.txt' );
  var expected = './foo/baz';
  test.identical( got, expected );

  //

  test.description = 'relative path #6';
  var got = _.pathWithoutExt( './foo/' );
  var expected = './foo/';
  test.identical( got, expected );

  //

  test.description = 'relative path #7';
  var got = _.pathWithoutExt( 'baz' );
  var expected = 'baz';
  test.identical( got, expected );

  //

  test.description = 'relative path #8';
  var got = _.pathWithoutExt( 'baz.a.b' );
  var expected = 'baz.a';
  test.identical( got, expected );

  //

  if( Config.debug )
  {
    test.description = 'passed argument is non string';
    test.shouldThrowErrorSync( function()
    {
      _.pathWithoutExt( null );
    });
  }
};

//

function pathChangeExt( test )
{
  test.description = 'empty ext';
  var got = _.pathChangeExt( 'some.txt', '' );
  var expected = 'some';
  test.identical( got, expected );

  //

  test.description = 'simple change extension';
  var got = _.pathChangeExt( 'some.txt', 'json' );
  var expected = 'some.json';
  test.identical( got, expected );

  //

  test.description = 'path with non empty dir name';
  var got = _.pathChangeExt( '/foo/bar/baz.asdf', 'txt' );
  var expected = '/foo/bar/baz.txt';
  test.identical( got, expected) ;

  //

  test.description = 'change extension of hidden file';
  var got = _.pathChangeExt( '/foo/bar/.baz', 'sh' );
  var expected = '/foo/bar/.baz.sh';
  test.identical( got, expected );

  //

  test.description = 'change extension in composite file name';
  var got = _.pathChangeExt( '/foo.coffee.md', 'min' );
  var expected = '/foo.coffee.min';
  test.identical( got, expected );

  //

  test.description = 'add extension to file without extension';
  var got = _.pathChangeExt( '/foo/bar/baz', 'txt' );
  var expected = '/foo/bar/baz.txt';
  test.identical( got, expected );

  //

  test.description = 'path folder contains dot, file without extension';
  var got = _.pathChangeExt( '/foo/baz.bar/some.md', 'txt' );
  var expected = '/foo/baz.bar/some.txt';
  test.identical( got, expected );

  //

  test.description = 'relative path #1';
  var got = _.pathChangeExt( './foo/.baz', 'txt' );
  var expected = './foo/.baz.txt';
  test.identical( got, expected );

  //

  test.description = 'relative path #2';
  var got = _.pathChangeExt( './.baz', 'txt' );
  var expected = './.baz.txt';
  test.identical( got, expected );

  //

  test.description = 'relative path #3';
  var got = _.pathChangeExt( '.baz', 'txt' );
  var expected = '.baz.txt';
  test.identical( got, expected );

  //

  test.description = 'relative path #4';
  var got = _.pathChangeExt( './baz', 'txt' );
  var expected = './baz.txt';
  test.identical( got, expected );

  //

  test.description = 'relative path #5';
  var got = _.pathChangeExt( './foo/baz', 'txt' );
  var expected = './foo/baz.txt';
  test.identical( got, expected );

  //

  test.description = 'relative path #6';
  var got = _.pathChangeExt( './foo/', 'txt' );
  var expected = './foo/.txt';
  test.identical( got, expected );

  //

  if( Config.debug )
  {
    test.description = 'passed argument is non string';
    test.shouldThrowErrorSync( function()
    {
      _.pathChangeExt( null, '' );
    });
  }

}

//

function pathRelative( test )
{

  var got;

  test.description = 'same path'; //

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
  var pathTo = '//aa/bb/cc/';
  var expected = '.';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'down path'; //

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
  var pathTo = '//aa/bb/';
  var expected = '..';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'relative to same path'; //
  var pathFrom = '/foo/bar/baz/asdf/quux';
  var pathTo = '/foo/bar/baz/asdf/quux';
  var expected = '.';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'relative to nested'; //
  var pathFrom = '/foo/bar/baz/asdf/quux';
  var pathTo = '/foo/bar/baz/asdf/quux/new1';
  var expected = 'new1';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'relative to parent directory'; //
  var pathFrom = '/foo/bar/baz/asdf/quux';
  var pathTo = '/foo/bar/baz/asdf';
  var expected = '..';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'relative to array of paths'; //
  var pathFrom4 = '/foo/bar/baz/asdf/quux/dir1/dir2';
  var pathTo4 =
  [
    '/foo/bar/baz/asdf/quux/dir1/dir2',
    '/foo/bar/baz/asdf/quux/dir1/',
    '/foo/bar/baz/asdf/quux/',
    '/foo/bar/baz/asdf/quux/dir1/dir2/dir3',
  ];
  var expected4 = [ '.', '..', '../..', 'dir3' ];
  var got = _.pathRelative( pathFrom4, pathTo4 );
  test.identical( got, expected4 );

  test.description = 'relative to array of paths, one of pathes is relative, allowRelative off'; //
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
    _.pathRelative( pathFrom4, pathTo4 );
  })
  debugger;

  test.description = 'absolute pathes'; //
  var pathFrom = _.pathRealMainDir();
  var pathTo = _.pathRealMainFile();
  var expected = _.pathName({ path : _.pathRealMainFile(), withExtension : 1 });
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'absolute pathes, pathFrom === pathTo'; //
  var pathFrom = _.pathRealMainDir();
  var pathTo = _.pathRealMainDir();
  var expected = '.';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'out of relative dir'; //
  var pathFrom = '/abc';
  var pathTo = '/a/b/z';
  var expected = '../a/b/z';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'out of relative dir'; //
  var pathFrom = '/abc/def';
  var pathTo = '/a/b/z';
  var expected = '../../a/b/z';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'relative root'; //
  var pathFrom = '/';
  var pathTo = '/a/b/z';
  var expected = 'a/b/z';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'relative root'; //
  var pathFrom = '/';
  var pathTo = '/a';
  var expected = 'a';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'relative root'; //
  var pathFrom = '/';
  var pathTo = '/';
  var expected = '.';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'windows disks'; //

  var pathFrom = 'd:/';
  var pathTo = 'c:/x/y';
  var expected = '../c/x/y';
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'long, not direct'; //

  var pathFrom = '/a/b/xx/yy/zz';
  var pathTo = '/a/b/file/x/y/z.txt';
  var expected = '../../../file/x/y/z.txt';
  debugger;
  var got = _.pathRelative( pathFrom, pathTo );
  test.identical( got, expected );

  test.description = 'both relative, long, not direct,allowRelative 1'; //

  var pathFrom = 'a/b/xx/yy/zz';
  var pathTo = 'a/b/file/x/y/z.txt';
  var expected = '../../../file/x/y/z.txt';
  debugger;
  var got = _.pathRelative({ relative :  pathFrom, path : pathTo, allowRelative : 1 });
  test.identical( got, expected );

  test.description = 'one relative, allowRelative 0'; //

  var pathFrom = 'c:/x/y';
  var pathTo = 'a/b/file/x/y/z.txt';
  var expected = '../../../file/x/y/z.txt';
  test.shouldThrowErrorSync( function()
  {
    _.pathRelative({ relative :  pathFrom, path : pathTo, allowRelative : 0 });
  })

  test.description = 'two relative, long, not direct'; //

  var pathFrom = 'a/b/xx/yy/zz';
  var pathTo = 'a/b/file/x/y/z.txt';
  var expected = '../../../file/x/y/z.txt';
  test.shouldThrowErrorSync( function()
  {
    _.pathRelative({ relative :  pathFrom, path : pathTo, allowRelative : 0 });
  })

  if( Config.debug ) //
  {
    test.description = 'missed arguments';
    test.shouldThrowErrorSync( function( )
    {
      _.pathRelative( pathFrom );
    } );

    test.description = 'extra arguments';
    test.shouldThrowErrorSync( function( )
    {
      _.pathRelative( pathFrom3, pathTo3, pathTo4 );
    } );

    test.description = 'second argument is not string or array';
    test.shouldThrowErrorSync( function( )
    {
      _.pathRelative( pathFrom3, null );
    } );
  }

};

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

  test.description = 'safe posix path';
  var got = _.pathIsSafe( path1 );
  test.identical( got, true );

  test.description = 'safe windows path';
  debugger;
  var got = _.pathIsSafe( path2 );
  test.identical( got, true );

  test.description = 'unsafe posix path ( hidden )';
  var got = _.pathIsSafe( path3 );
  test.identical( got, false );

  test.description = 'safe posix path with "." segment';
  var got = _.pathIsSafe( path4 );
  test.identical( got, true );

  test.description = 'unsafe windows path';
  var got = _.pathIsSafe( path5 );
  test.identical( got, false );

  test.description = 'unsafe windows path';
  var got = _.pathIsSafe( path6 );
  test.identical( got, false );

  test.description = 'unsafe short path';
  var got = _.pathIsSafe( path7 );
  test.identical( got, false );

  test.description = 'unsafe short path';
  var got = _.pathIsSafe( path8 );
  test.identical( got, false );

  // test.identical( 0,1 );

  if( Config.debug )
  {
    test.description = 'missed arguments';
    test.shouldThrowErrorSync( function( )
    {
      _.pathIsSafe( );
    });

    test.description = 'second argument is not string';
    test.shouldThrowErrorSync( function( )
    {
      _.pathIsSafe( null );
    });
  }

}

//

function pathCommon( test )
{
  test.description = 'absolute-absolute'

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
  test.identical( got, '/a/b' );

  var got = _.pathCommon([ '/./a/./b/./c', '/a/b' ]);
  test.identical( got, '/a/b' );

  var got = _.pathCommon([ '/A/b/c', '/a/b/c' ]);
  test.identical( got, '/' );

  var got = _.pathCommon([ '/', '/x' ]);
  test.identical( got, '/' );

  var got = _.pathCommon([ '/a', '/x'  ]);
  test.identical( got, '/' );

  test.description = 'absolute-relative'

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

  test.description = 'relative-relative'

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

  test.description = 'several absolute paths'

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

  test.description = 'several relative paths';

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

// --
// proto
// --

var Self =
{

  name : 'PathTest',
  // verbosity : 7,
  // routine : 'pathRelative',

  tests :
  {

    pathRefine : pathRefine,
    pathIsRefined : pathIsRefined,
    pathRegularize : pathRegularize,

    _pathJoinAct : _pathJoinAct,
    pathJoin : pathJoin,
    pathReroot : pathReroot,
    pathResolve : pathResolve,

    pathDir : pathDir,
    pathExt : pathExt,
    pathPrefix : pathPrefix,
    pathName : pathName,
    pathCurrent : pathCurrent,
    pathWithoutExt : pathWithoutExt,
    pathChangeExt : pathChangeExt,

    pathRelative : pathRelative,
    pathIsSafe : pathIsSafe,

    pathCommon : pathCommon

  },

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self.name );

if( 0 )
if( typeof module === 'undefined' )
_.timeReady( function()
{

  _.Testing.verbosity = 99;
  _.Testing.logger = wPrinterToJstructure({ coloring : 1, writingToHtml : 1 });
  _.Testing.test( Self.name,'PathUrlTest' )
  .doThen( function()
  {
    var book = _.Testing.loggerToBook();
  });

});

})();
