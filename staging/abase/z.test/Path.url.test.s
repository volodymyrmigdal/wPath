( function _Path_url_test_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

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

  _.include( 'wTesting' );
  require( '../component/Path.s' );

}

var _ = wTools;

//

function urlRefine( test )
{
  test.description = 'refine the url';

  var cases =
  [
    { src : '', error : true },
    { src : 'a', expected : 'a' },
    { src : 'a/b', expected : 'a/b' },
    { src : 'a\\b', expected : 'a/b' },
    { src : '\\a\\b\\c', expected : '/a/b/c' },
    { src : '\\\\a\\\\b\\\\c', expected : '//a//b//c' },
    { src : '\\\\\\', expected : '///' },
    { src : '/', expected : '/' },
    { src : '//', expected : '//' },
    { src : '///', expected : '///' },
  ]

  debugger;

  for( var i = 0; i < cases.length; i++ )
  {
    var c = cases[ i ];
    if( c.error )
    test.shouldThrowError( () => _.urlRefine( c.src ) );
    else
    test.identical( _.urlRefine( c.src ), c.expected );
  }

  debugger;
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
      expected : [ 'a/b', 'a/b', '/a/b/c', '//a//b//c', '///' ]
    },
    {
      src : _.arrayToMap( [ 'a/b', 'a\\b', '\\a\\b\\c', '\\\\a\\\\b\\\\c', '\\\\\\' ] ),
      expected : _.arrayToMap( [ 'a/b', 'a/b', '/a/b/c', '//a//b//c', '///' ] )
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
  var options =
    {
      atomicOnly: true
    },

    url1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor',

    expected1 =
    {
      protocol : 'http',
      host : 'www.site.com',
      port : '13',
      pathname : '/path/name',
      query : 'query=here&and=here',
      hash : 'anchor',

      hostname : 'www.site.com:13',
      origin : 'http://www.site.com:13'
    },

    expected2 =
    {
      protocol : 'http',
      host : 'www.site.com',
      port : '13',
      pathname : '/path/name',
      query : 'query=here&and=here',
      hash : 'anchor'
    };

  test.description = 'full url with all components';
  var got = _.urlParse( url1 );
  test.contain( got, expected1 );

  test.description = 'full url with all components, atomicOnly';
  var got = _.urlParse( url1, options );
  test.contain( got, expected2 );

  if( Config.debug )
  {

    test.description = 'missed arguments';
    test.shouldThrowErrorSync( function()
    {
      _.urlParse();
    });

    test.description = 'argument is not string';
    test.shouldThrowErrorSync( function()
    {
      _.urlParse( 34 );
    });

  }

};

//

function urlMake( test )
{
  var url = 'http://www.site.com:13/path/name?query=here&and=here#anchor',
    components0 =
    {
      url : url
    },
    components1 =
    {
      protocol : 'http',
      host : 'www.site.com',
      port : '13',
      pathname : '/path/name',
      query : 'query=here&and=here',
      hash : 'anchor',
    },
    components2 =
    {
      pathname : '/path/name',
      query : 'query=here&and=here',
      hash : 'anchor',

      origin: 'http://www.site.com:13'
    },
    components3 =
    {
      protocol : 'http',
      pathname : '/path/name',
      query : 'query=here&and=here',
      hash : 'anchor',

      hostname : 'www.site.com:13'
    },
    expected1 = url;

  test.description = 'make url from components url';
  var got = _.urlMake( components0 );
  test.identical( got, expected1 );

  test.description = 'make url from atomic components';
  var got = _.urlMake( components1 );
  test.identical( got, expected1 );

  test.description = 'make url from composites components: origin';
  var got = _.urlMake( components2 );
  test.identical( got, expected1 );

  test.description = 'make url from composites components: hostname';
  var got = _.urlMake( components3 );
  test.identical( got, expected1 );

  //

  if( Config.debug )
  {

    test.description = 'missed arguments';
    test.shouldThrowErrorSync( function()
    {
      _.urlMake();
    });

    test.description = 'argument is not url component object';
    test.shouldThrowErrorSync( function()
    {
      debugger
      _.urlMake( url );
    });

  }
}

//

function urlFor( test )
{
  var urlString = 'http://www.site.com:13/path/name?query=here&and=here#anchor',
    options1 = {
      url: urlString
    },
    expected1 = urlString;

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

  test.description = 'server with path join absolute path 2';
  var got = _.urlJoin( 'http://www.site.com:13/xxx','/y','/z' );
  test.identical( got, 'http://www.site.com:13/z' );

}

// --
// proto
// --

var Self =
{

  name : 'PathUrlTest',

  tests :
  {
    urlRefine : urlRefine,
    urlsRefine : urlsRefine,
    urlParse : urlParse,
    urlMake : urlMake,
    urlFor : urlFor,
    urlDocument : urlDocument,
    serverUrl : serverUrl,
    urlQuery : urlQuery,
    urlDequery : urlDequery,

    urlJoin : urlJoin,

  },

};

Self = wTestSuite( Self );

if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self );

} )( );
