( function _Path_url_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  //if( typeof wBase === 'undefined' )
  try
  {
    require( '../../Base.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wTesting' );
  require( '../layer3/PathTools.s' );

}

var _ = wTools;

//

function urlRefine( test )
{
  test.description = 'refine the url';

  var cases =
  [
    { src : '', error : true },

    { src : 'a/', expected : 'a' },
    { src : 'a//', expected : '/a//' },
    { src : 'a\\', expected : 'a' },
    { src : 'a\\\\', expected : 'a' },

    { src : 'a', expected : 'a' },
    { src : 'a/b', expected : 'a/b' },
    { src : 'a\\b', expected : 'a/b' },
    { src : '\\a\\b\\c', expected : '/a/b/c' },
    { src : '\\\\a\\\\b\\\\c', expected : '/a/b/c' },
    { src : '\\', expected : '/' },
    { src : '\\\\', expected : '/' },
    { src : '\\\\\\', expected : '/' },
    { src : '/', expected : '/' },
    { src : '//', expected : '//' },
    { src : '///', expected : '///' },
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    test.shouldThrowError( () => _.urlRefine( c.src ) );
    else
    test.identical( _.urlRefine( c.src ), c.expected );
  }

}

//

function urlsRefine( test )
{
  test.description = 'refine the urls';

  var cases =
  [
    { src : [ '' ], error : true },
    { src : [ 'a', 'b', '' ], error : true },
    { src : [ 'a', 'b', 'c' ], expected : [ 'a', 'b', 'c' ] },
    {
      src : [ 'a/b', 'a\\b', '\\a\\b\\c', '\\\\a\\\\b\\\\c', '\\\\\\' ],
      expected : [ 'a/b', 'a/b', '/a/b/c', '/a/b/c', '/' ]
    },
    {
      src : _.arrayToMap([ 'a/b', 'a\\b', '\\a\\b\\c', '\\\\a\\\\b\\\\c', '\\\\\\' ]),
      expected : _.arrayToMap([ 'a/b', 'a/b', '/a/b/c', '/a/b/c', '/' ])
    }
  ]

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    test.shouldThrowError( () => _.urlsRefine( c.src ) );
    else
    test.identical( _.urlsRefine( c.src ), c.expected )
  }
}

//

function urlParse( test )
{

  var url1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';

  test.description = 'full url with all components';  /* */

  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : '13',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
    protocols : [ 'http' ],
    hostWithPort : 'www.site.com:13',
    origin : 'http://www.site.com:13',
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor',
  }

  var got = _.urlParse( url1 );
  test.identical( got, expected );

  test.description = 'full url with all components, primitiveOnly'; /* */

  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : '13',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var got = _.urlParsePrimitiveOnly( url1 );
  test.identical( got, expected );

  test.description = 'reparse with non primitives';

  var expected =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : '13',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    protocols : [ 'http' ],
    hostWithPort : 'www.site.com:13',
    origin : 'http://www.site.com:13',
    full : 'http://www.site.com:13/path/name?query=here&and=here#anchor',

  }

  var parsed = got;
  var got = _.urlParse( parsed );
  test.identical( got, expected );

  test.description = 'url with zero length protocol'; /* */

  var url = '://some.domain.com/something/to/add';

  var expected =
  {
    protocol : '',
    host : 'some.domain.com',
    localPath : '/something/to/add',
    protocols : [ '' ],
    hostWithPort : 'some.domain.com',
    origin : '://some.domain.com',
    full : '://some.domain.com/something/to/add',
  }

  var got = _.urlParse( url );
  test.identical( got, expected );

  test.description = 'url with zero length hostWithPort'; /* */

  var url = 'file:///something/to/add';

  var expected =
  {
    protocol : 'file',
    host : '',
    localPath : '/something/to/add',
    protocols : [ 'file' ],
    hostWithPort : '',
    origin : 'file://',
    full : 'file:///something/to/add',
  }

  var got = _.urlParse( url );
  test.identical( got, expected );

  test.description = 'url with double protocol'; /* */

  var url = 'svn+https://user@subversion.com/svn/trunk';

  var expected =
  {
    protocol : 'svn+https',
    host : 'user@subversion.com',
    localPath : '/svn/trunk',
    protocols : [ 'svn','https' ],
    hostWithPort : 'user@subversion.com',
    origin : 'svn+https://user@subversion.com',
    full : 'svn+https://user@subversion.com/svn/trunk',
  }

  var got = _.urlParse( url );
  test.identical( got, expected );

  test.description = 'simple path'; /* */

  var url = '/some/file';

  var expected =
  {
    localPath : '/some/file',
    protocols : [],
    full : '/some/file',
  }

  var got = _.urlParse( url );
  test.identical( got, expected );

  test.description = 'simple path'; /* */

  var url = '//some.domain.com/was';
  var expected =
  {
    host : 'some.domain.com',
    localPath : '/was',
    protocols : [],
    hostWithPort : 'some.domain.com',
    origin : '//some.domain.com',
    full : '//some.domain.com/was',
  }

  var got = _.urlParse( url );
  test.identical( got, expected );

  if( Config.debug )  /* */
  {

    test.description = 'missed arguments';
    test.shouldThrowErrorSync( function()
    {
      _.urlParse();
    });

    test.description = 'redundant argument';
    test.shouldThrowErrorSync( function()
    {
      _.urlParse( 'http://www.site.com:13/path/name?query=here&and=here#anchor','' );
    });

    test.description = 'argument is not string';
    test.shouldThrowErrorSync( function()
    {
      _.urlParse( 34 );
    });

  }

}

//

function urlStr( test )
{
  var url = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var components0 =
  {
    full : url
  }

  var components2 =
  {
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    origin: 'http://www.site.com:13'
  }

  var components3 =
  {
    protocol : 'http',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',

    hostWithPort : 'www.site.com:13'
  }

  var expected1 = url;

  test.description = 'make url from components url';  /* */
  var got = _.urlStr( components0 );
  test.identical( got, expected1 );

  test.description = 'make url from atomic components'; /* */

  var components =
  {
    protocol : 'http',
    host : 'www.site.com',
    port : '13',
    localPath : '/path/name',
    query : 'query=here&and=here',
    hash : 'anchor',
  }

  var got = _.urlStr( components );
  test.identical( got, expected1 );

  test.description = 'make url from composites components: origin'; /* */
  var got = _.urlStr( components2 );
  test.identical( got, expected1 );

  test.description = 'make url from composites components: hostWithPort'; /* */
  var got = _.urlStr( components3 );
  test.identical( got, expected1 );

  test.description = 'make url from composites components: hostWithPort'; /* */
  var expected = '//some.domain.com/was';
  var components =
  {
    host : 'some.domain.com',
    localPath : '/was',
  }
  debugger;
  var got = _.urlStr( components );
  test.identical( got, expected );

  //

  if( Config.debug )
  {

    test.description = 'missed arguments';
    test.shouldThrowErrorSync( function()
    {
      _.urlStr();
    });

    test.description = 'argument is not url component object';
    test.shouldThrowErrorSync( function()
    {
      debugger
      _.urlStr( url );
    });

  }
}

//

function urlFor( test )
{
  var urlString = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var options1 =
  {
    full : urlString,
  }
  var expected1 = urlString;

  test.description = 'call with options.url';
  var got = _.urlFor( options1 );
  test.contain( got, expected1 );

  if( Config.debug )
  {

    test.description = 'missed arguments';
    test.shouldThrowErrorSync( function()
    {
      _.urlFor();
    });

  }
};

//

function urlDocument( test )
{

  var url1 = 'https://www.site.com:13/path/name?query=here&and=here#anchor',
    url2 = 'www.site.com:13/path/name?query=here&and=here#anchor',
    url3 = 'http://www.site.com:13/path/name',
    options1 = { withoutServer: 1 },
    options2 = { withoutProtocol: 1 },
    expected1 = 'https://www.site.com:13/path/name',
    expected2 = 'http://www.site.com:13/path/name',
    expected3 = 'www.site.com:13/path/name',
    expected4 = '/path/name';

  test.description = 'full components url';
  var got = _.urlDocument( url1 );
  test.contain( got, expected1 );

  test.description = 'url without protocol';
  var got = _.urlDocument( url2 );
  test.contain( got, expected2 );

  test.description = 'url without query, options withoutProtocol = 1';
  var got = _.urlDocument( url3, options2 );
  test.contain( got, expected3 );

  test.description = 'get path only';
  var got = _.urlDocument( url1, options1 );
  test.contain( got, expected4 );

};

//

function serverUrl( test )
{
  var urlString = 'http://www.site.com:13/path/name?query=here&and=here#anchor',
    expected = 'http://www.site.com:13/';

  test.description = 'get server part of url';
  var got = _.urlServer( urlString );
  test.contain( got, expected );

};

//

function urlQuery( test )
{
  var urlString = 'http://www.site.com:13/path/name?query=here&and=here#anchor',
    expected = 'query=here&and=here#anchor';

  test.description = 'get query part of url';
  var got = _.urlQuery( urlString );
  test.contain( got, expected );

};

//

function urlDequery( test )
{
  var query1 = 'key=value',
    query2 = 'key1=value1&key2=value2&key3=value3',
    query3 = 'k1=&k2=v2%20v3&k3=v4_v4',
    expected1 = { key: 'value' },
    expected2 =
    {
      key1 : 'value1',
      key2 : 'value2',
      key3 : 'value3'
    },
    expected3 =
    {
      k1: '',
      k2: 'v2 v3',
      k3: 'v4_v4'
    };

  test.description = 'parse simpliest query';
  var got = _.urlDequery( query1 );
  test.contain( got, expected1 );

  test.description = 'parse query with several key/value pair';
  var got = _.urlDequery( query2 );
  test.contain( got, expected2 );

  test.description = 'parse query with several key/value pair and decoding';
  var got = _.urlDequery( query3 );
  test.contain( got, expected3 );

  // test.description = 'parse query with similar keys';
  // var got = _.urlDequery( query4 );
  // test.contain( got, expected4 );

}

//

function urlJoin( test )
{

  test.description = 'server join absolute path 1';
  var got = _.urlJoin( 'http://www.site.com:13','/x','/y','/z' );
  test.identical( got, 'http://www.site.com:13/z' );

  test.description = 'server join absolute path 2';
  var got = _.urlJoin( 'http://www.site.com:13/','x','/y','/z' );
  test.identical( got, 'http://www.site.com:13/z' );

  test.description = 'server join absolute path 2';
  var got = _.urlJoin( 'http://www.site.com:13/','x','y','/z' );
  test.identical( got, 'http://www.site.com:13/z' );

  test.description = 'server join absolute path';
  var got = _.urlJoin( 'http://www.site.com:13/','x','/y','z' );
  test.identical( got, 'http://www.site.com:13/y/z' );

  test.description = 'server join relative path';
  var got = _.urlJoin( 'http://www.site.com:13/','x','y','z' );
  test.identical( got, 'http://www.site.com:13/x/y/z' );

  test.description = 'server with path join absolute path 2';
  var got = _.urlJoin( 'http://www.site.com:13/xxx','/y','/z' );
  test.identical( got, 'http://www.site.com:13/z' );

  test.description = 'server with path join absolute path 2';
  var got = _.urlJoin( 'http://www.site.com:13/xxx','/y','z' );
  test.identical( got, 'http://www.site.com:13/y/z' );

  test.description = 'server with path join absolute path 2';
  var got = _.urlJoin( 'http://www.site.com:13/xxx','y','z' );
  test.identical( got, 'http://www.site.com:13/xxx/y/z' );

  test.description = 'add relative to url with no localPath';
  var got = _.urlJoin( 'https://some.domain.com/','something/to/add' );
  test.identical( got, 'https://some.domain.com/something/to/add' );

  test.description = 'add relative to url with localPath';
  var got = _.urlJoin( 'https://some.domain.com/was','something/to/add' );
  test.identical( got, 'https://some.domain.com/was/something/to/add' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( 'https://some.domain.com/was','/something/to/add' );
  test.identical( got, 'https://some.domain.com/something/to/add' );

  test.description = 'add absolute to url with localPath';
  debugger;
  var got = _.urlJoin( '//some.domain.com/was','/something/to/add' );
  test.identical( got, '//some.domain.com/something/to/add' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '://some.domain.com/was','/something/to/add' );
  test.identical( got, '://some.domain.com/something/to/add' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( 'file:///some/file','/something/to/add' );
  test.identical( got, 'file:///something/to/add' );

/*
  _.urlJoin( 'https://some.domain.com/','something/to/add' ) -> 'https://some.domain.com/something/to/add'
  _.urlJoin( 'https://some.domain.com/was','something/to/add' ) -> 'https://some.domain.com/was/something/to/add'
  _.urlJoin( 'https://some.domain.com/was','/something/to/add' ) -> 'https://some.domain.com/something/to/add'

  _.urlJoin( '//some.domain.com/was','/something/to/add' ) -> '//some.domain.com/something/to/add'
  _.urlJoin( '://some.domain.com/was','/something/to/add' ) -> '://some.domain.com/something/to/add'

file:///some/staging/index.html
file:///some/staging/index.html
http://some.come/staging/index.html
svn+https://user@subversion.com/svn/trunk

*/

}

//

function urlName( test )
{
  var paths =
  [
    '',
    'some.txt',
    '/foo/bar/baz.asdf',
    '/foo/bar/.baz',
    '/foo.coffee.md',
    '/foo/bar/baz',
  ]

  var expectedExt =
  [
    '',
    'some.txt',
    'baz.asdf',
    '.baz',
    'foo.coffee.md',
    'baz'
  ]

  var expectedNoExt =
  [
    '',
    'some',
    'baz',
    '',
    'foo.coffee',
    'baz'
  ]

  test.description = 'urlName works like pathName'
  paths.forEach( ( path, i ) =>
  {
    var got = _.urlName( path );
    var expectedFromPath = _.pathName( path );
    test.identical( got, expectedFromPath );
    var exp = expectedNoExt[ i ];
    test.identical( got, exp );

    var o = { path : path, withExtension : 1 };
    var got = _.urlName( o );
    var expectedFromPath = _.pathName( o );
    test.identical( got, expectedFromPath );
    var exp = expectedExt[ i ];
    test.identical( got, exp );
  })

  //

  test.description = 'url to file';
  var url = 'http://www.site.com:13/path/name.txt'
  var got = _.urlName( url );
  var expected = 'name';
  test.identical( got, expected );

  test.description = 'url with params';
  var url1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.urlName( url );
  var expected = 'name';
  test.identical( got, expected );

  test.description = 'url without protocol';
  var url1 = '://www.site.com:13/path/name.js';
  var got = _.urlName( url );
  var expected = 'name';
  test.identical( got, expected );

  //

  test.description = 'url to file, withExtension';
  var url = 'http://www.site.com:13/path/name.txt'
  var got = _.urlName({ path : url, withExtension : 1 } );
  var expected = 'name.txt';
  test.identical( got, expected );

  test.description = 'url with params, withExtension';
  var url = 'http://www.site.com:13/path/name.js?query=here&and=here#anchor';
  var got = _.urlName({ path : url, withExtension : 1 } );
  var expected = 'name.js';
  test.identical( got, expected );

  test.description = 'url without protocol, withExtension';
  var url = '://www.site.com:13/path/name.js';
  var got = _.urlName({ path : url, withExtension : 1 } );
  var expected = 'name.js';
  test.identical( got, expected );

  test.description = 'url without localPath';
  var url = '://www.site.com:13';
  var got = _.urlName({ path : url });
  var expected = '';
  test.identical( got, expected );

  if( !Config.debug )
  return;

  test.description = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.urlName( false );
  });
};

// --
// proto
// --

var Self =
{

  name : 'PathUrlTest',
  silencing : 1,

  tests :
  {
    urlRefine : urlRefine,
    urlsRefine : urlsRefine,
    urlParse : urlParse,
    urlStr : urlStr,
    urlFor : urlFor,
    urlDocument : urlDocument,
    serverUrl : serverUrl,
    urlQuery : urlQuery,
    urlDequery : urlDequery,

    urlJoin : urlJoin,

    urlName : urlName,

  },

};

Self = wTestSuite( Self );

if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self );

} )( );
