( function _Path_path_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../../abase/wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wTesting' );
  _.include( 'wPath' );

}

var _ = wTools;
var sourceFilePath = _.diagnosticLocation().full; // typeof module !== 'undefined' ? __filename : document.scripts[ document.scripts.length-1 ].src;

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

}

//

function _pathJoin( test )
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
  paths2 = [ 'c:\\', 'foo\\', 'bar\\' ],
  paths3 = [ '/bar/', '/', 'foo/' ],
  paths4 = [ '/bar/', '/baz', 'foo/' ],

  expected1 = 'http://www.site.com:13/bar/foo',
  expected2 = '/c/foo/bar',
  expected3 = '/foo',
  expected4 = '/bar/baz/foo';

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
    test.shouldThrowError( function()
    {
      _.pathJoin();
    });

    test.description = 'non string passed';
    test.shouldThrowError( function()
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
    test.shouldThrowError( function()
    {
      _.pathJoin();
    });

    test.description = 'not string passed';
    test.shouldThrowError( function()
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

  var paths = [  'aa','cc','..','..','..' ];
  var expected = _.strCutOffRight( _.pathCurrent(),'/' )[ 0 ];
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

  if( Config.debug ) //
  {

    test.description = 'nothing passed';
    test.shouldThrowError( function()
    {
      _.pathResolve();
    });

    test.description = 'non string passed';
    test.shouldThrowError( function()
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
    test.shouldThrowError( function()
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
    test.shouldThrowError( function()
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
    test.shouldThrowError( function()
    {
      _.pathName( false );
    });
  }
};

//

function pathWithoutExt( test )
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

function pathChangeExt( test )
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

  // test.description = 'using file record'; //
  // var path5 = 'tmp/pathRelative/foo/bar/test';
  // var pathTo5 = 'tmp/pathRelative/foo/';
  // var expected5 = '../..';
  // // createTestFile( path5 );
  // var fr = wFileRecord( Path.resolve( mergePath( path5 ) ) );
  // var got =  _.pathRelative( fr, Path.resolve( mergePath( pathTo5 ) ) );
  // test.identical( got, expected5 );

  if( Config.debug ) //
  {
    test.description = 'missed arguments';
    test.shouldThrowError( function( )
    {
      _.pathRelative( pathFrom );
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

function pathIsSafe( test )
{
  var path1 = '/home/user/dir1/dir2',
    path2 = 'C:/foo/baz/bar',
    path3 = '/foo/bar/.hidden',
    path4 = '/foo/./somedir',
    path5 = 'c:foo/',
    got;

  test.description = 'safe posix path';
  var got = _.pathIsSafe( path1 );
  test.identical( got, true );

  test.description = 'safe windows path';
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

  test.indentical( 0,1 );

  if( Config.debug )
  {
    test.description = 'missed arguments';
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
}

// --
// proto
// --

var Self =
{

  name : 'PathTest',
  sourceFilePath : sourceFilePath,
  verbosity : 1,

  tests :
  {

    pathRefine : pathRefine,
    pathIsRefined : pathIsRefined,
    pathRegularize : pathRegularize,

    // _pathJoin : _pathJoin,
    // pathJoin : pathJoin,
    // pathReroot : pathReroot,
    // pathResolve : pathResolve,

    pathDir : pathDir,
    pathExt : pathExt,
    pathPrefix : pathPrefix,
    // pathName : pathName,
    pathWithoutExt : pathWithoutExt,
    pathChangeExt : pathChangeExt,

    pathRelative : pathRelative,
    pathIsSafe : pathIsSafe,

  },

}

Self = wTestSuite( Self );

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test( Self.name );

if( 0 )
_.timeReady( function()
{

  _.Testing.logger = wLoggerToJstructure({ coloring : 0 });
  _.Testing.test( Self.name )
  .doThen( function()
  {
    var book = _.Testing.loggerToBook();
  });

});

})();
