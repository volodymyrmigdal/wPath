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
    { src : 'a\\\\', expected : 'a//' },

    { src : 'a', expected : 'a' },
    { src : 'a/b', expected : 'a/b' },
    { src : 'a\\b', expected : 'a/b' },
    { src : '\\a\\b\\c', expected : '/a/b/c' },
    { src : '\\\\a\\\\b\\\\c', expected : '//a//b//c' },
    { src : '\\', expected : '/' },
    { src : '\\\\', expected : '//' },
    { src : '\\\\\\', expected : '///' },
    { src : '/', expected : '/' },
    { src : '//', expected : '//' },
    { src : '///', expected : '///' },

    {
      src : '/some/staging/index.html',
      expected : '/some/staging/index.html'
    },
    {
      src : '/some/staging/index.html/',
      expected : '/some/staging/index.html'
    },
    {
      src : '//some/staging/index.html',
      expected : '//some/staging/index.html'
    },
    {
      src : '//some/staging/index.html/',
      expected : '//some/staging/index.html'
    },
    {
      src : '///some/staging/index.html',
      expected : '///some/staging/index.html'
    },
    {
      src : '///some/staging/index.html/',
      expected : '///some/staging/index.html'
    },
    {
      src : 'file:///some/staging/index.html',
      expected : 'file:///some/staging/index.html'
    },
    {
      src : 'file:///some/staging/index.html/',
      expected : 'file:///some/staging/index.html'
    },
    {
      src : 'http://some.come/staging/index.html',
      expected : 'http://some.come/staging/index.html'
    },
    {
      src : 'http://some.come/staging/index.html/',
      expected : 'http://some.come/staging/index.html'
    },
    {
      src : 'svn+https://user@subversion.com/svn/trunk',
      expected : 'svn+https://user@subversion.com/svn/trunk'
    },
    {
      src : 'svn+https://user@subversion.com/svn/trunk/',
      expected : 'svn+https://user@subversion.com/svn/trunk'
    },
    {
      src : 'complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor',
      expected : 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
    },
    {
      src : 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
      expected : 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor'
    },
    {
      src : 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking',
      expected : 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking'
    },
    {
      src : 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking',
      expected : 'https://web.archive.org//web//*//http://www.heritage.org//index//ranking'
    },
    {
      src : '://www.site.com:13/path//name//?query=here&and=here#anchor',
      expected : '://www.site.com:13/path//name//?query=here&and=here#anchor'
    },
    {
      src : ':///www.site.com:13/path//name/?query=here&and=here#anchor',
      expected : ':///www.site.com:13/path//name?query=here&and=here#anchor'
    },
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

  var srcs =
  [
    '/some/staging/index.html',
    '/some/staging/index.html/',
    '//some/staging/index.html',
    '//some/staging/index.html/',
    '///some/staging/index.html',
    '///some/staging/index.html/',
    'file:///some/staging/index.html',
    'file:///some/staging/index.html/',
    'http://some.come/staging/index.html',
    'http://some.come/staging/index.html/',
    'svn+https://user@subversion.com/svn/trunk',
    'svn+https://user@subversion.com/svn/trunk/',
    'complex+protocol://www.site.com:13/path/name/?query=here&and=here#anchor',
    'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
    'https://web.archive.org/web/*/http://www.heritage.org/index/ranking',
    'https://web.archive.org//web//*//http://www.heritage.org//index//ranking',
    '://www.site.com:13/path//name//?query=here&and=here#anchor',
    ':///www.site.com:13/path//name/?query=here&and=here#anchor',
  ]

  var expected =
  [
    '/some/staging/index.html',
    '/some/staging/index.html',
    '//some/staging/index.html',
    '//some/staging/index.html',
    '///some/staging/index.html',
    '///some/staging/index.html',
    'file:///some/staging/index.html',
    'file:///some/staging/index.html',
    'http://some.come/staging/index.html',
    'http://some.come/staging/index.html',
    'svn+https://user@subversion.com/svn/trunk',
    'svn+https://user@subversion.com/svn/trunk',
    'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
    'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor',
    'https://web.archive.org/web/*/http://www.heritage.org/index/ranking',
    'https://web.archive.org//web//*//http://www.heritage.org//index//ranking',
    '://www.site.com:13/path//name//?query=here&and=here#anchor',
    ':///www.site.com:13/path//name?query=here&and=here#anchor'
  ]

  var got = _.urlsRefine( srcs );
  test.identical( got, expected );
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

  test.description = 'reparse with primitives';

  var url1 = 'http://www.site.com:13/path/name?query=here&and=here#anchor';
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

  test.description = 'simple path'; /* */

  var url = '//';
  var expected =
  {
    host : '',
    localPath : '',
    protocols : [],
    hostWithPort : '',
    origin : '//',
    full : '//'
  }

  var got = _.urlParse( url );
  test.identical( got, expected );

  var url = '///';
  var expected =
  {
    host : '',
    localPath : '/',
    protocols : [],
    hostWithPort : '',
    origin : '//',
    full : '///'
  }

  var got = _.urlParse( url );
  test.identical( got, expected );

  var url = '///a/b/c';
  var expected =
  {
    host : '',
    localPath : '/a/b/c',
    protocols : [],
    hostWithPort : '',
    origin : '//',
    full : '///a/b/c'
  }

  var got = _.urlParse( url );
  test.identical( got, expected )

  test.description = 'complex';
  var url = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var expected =
  {
    protocol : 'complex+protocol',
    host : 'www.site.com',
    localPath : '/path/name',
    port : '13',
    query : 'query=here&and=here',
    hash : 'anchor',
    protocols : [ 'complex', 'protocol' ],
    hostWithPort : 'www.site.com:13',
    origin : 'complex+protocol://www.site.com:13',
    full : url
  }

  var got = _.urlParse( url );
  test.identical( got, expected );


  test.description = 'complex, parsePrimitiveOnly + urlStr';
  var url = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var got = _.urlParsePrimitiveOnly( url );
  var expected =
  {
    protocol : 'complex+protocol',
    host : 'www.site.com',
    localPath : '/path/name',
    port : '13',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  test.identical( got, expected );
  var newUrl = _.urlStr( got );
  test.identical( newUrl, url );

  var url = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.urlParse( url );
  var expected =
  {
    protocol : '',
    host : 'www.site.com',
    localPath : '/path//name//',
    port : '13',
    query : 'query=here&and=here',
    hash : 'anchor',
    protocols : [ '' ],
    hostWithPort : 'www.site.com:13',
    origin : '://www.site.com:13',
    full : url
  }
  test.identical( got, expected );

  var url = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.urlParsePrimitiveOnly( url );
  var expected =
  {
    protocol : '',
    host : 'www.site.com',
    localPath : '/path//name//',
    port : '13',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
  test.identical( got, expected );

  var url = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.urlParse( url );
  var expected =
  {
    protocol : '',
    host : '',
    localPath : '/www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
    protocols : [ '' ],
    hostWithPort : '',
    origin : '://',
    full : url
  }
  test.identical( got, expected );

  var url = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var got = _.urlParsePrimitiveOnly( url );
  var expected =
  {
    protocol : '',
    host : '',
    localPath : '/www.site.com:13/path//name//',
    query : 'query=here&and=here',
    hash : 'anchor',
  }
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

  var url = '/some/staging/index.html';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '//some/staging/index.html';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '//www.site.com/index.html';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '///index.html';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '//www.site.com:/index.html';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '//www.site.com:13/index.html';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '//www.site.com:13/index.html?query=here&and=here#anchor';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '///some/staging/index.html';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '///some.com:99/staging/index.html';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '///some.com:99/staging/index.html?query=here&and=here#anchor';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'file:///some/staging/index.html';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'file:///some.com:/staging/index.html?query=here&and=here#anchor';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'http://some.come/staging/index.html';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'http://some.come:88/staging/index.html';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'http://some.come:88/staging/?query=here&and=here#anchor';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'svn+https://user@subversion.com/svn/trunk';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'svn+https://user@subversion.com:99/svn/trunk';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'complex+protocol://www.site.com:13/path/name?';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'complex+protocol://www.site.com:13/path/name?#';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'https://web.archive.org/web/*/http://www.heritage.org/index/ranking';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '://www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = ':///www.site.com:13/path//name//?query=here&and=here#anchor';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = 'protocol://';
  var parsed = _.urlParse( url );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '//:99';
  var parsed = _.urlParse( url );
  test.identical( parsed.port, '99' );
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  test.identical( parsedPrimitive.port, '99' );
  var fromParsed = _.urlStr( parsed );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsed, url );
  test.identical( fromParsedPrimitive, url );

  var url = '//?q=1#x';
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var parsed = _.urlParse( url );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsedPrimitive, url );
  var fromParsed = _.urlStr( parsed );
  test.identical( fromParsed, url );

  var url = '//';
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var parsed = _.urlParse( url );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsedPrimitive, url );
  var fromParsed = _.urlStr( parsed );
  test.identical( fromParsed, url );

  var url = '//a/b/c';
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var parsed = _.urlParse( url );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsedPrimitive, url );
  var fromParsed = _.urlStr( parsed );
  test.identical( fromParsed, url );

  var url = '///';
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var parsed = _.urlParse( url );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsedPrimitive, url );
  var fromParsed = _.urlStr( parsed );
  test.identical( fromParsed, url );

  var url = '///a/b/c';
  var parsedPrimitive = _.urlParsePrimitiveOnly( url );
  var parsed = _.urlParse( url );
  var fromParsedPrimitive = _.urlStr( parsedPrimitive );
  test.identical( fromParsedPrimitive, url );
  var fromParsed = _.urlStr( parsed );
  test.identical( fromParsed, url );

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

  //

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '//some.domain.com/was','/something/to/add' );
  test.identical( got, '//some.domain.com/something/to/add' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '//some.domain.com/was', 'x', '/something/to/add' );
  test.identical( got, '//some.domain.com/something/to/add' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '//some.domain.com/was', '/something/to/add', 'x' );
  test.identical( got, '//some.domain.com/something/to/add/x' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '//some.domain.com/was', '/something/to/add', '/x' );
  test.identical( got, '//some.domain.com/x' );

  //

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '/some/staging/index.html','/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '/some/staging/index.html', 'x', '/something/to/add' );
  test.identical( got, '/something/to/add' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '/some/staging/index.html', 'x', '/something/to/add', 'y' );
  test.identical( got, '/something/to/add/y' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '/some/staging/index.html','/something/to/add', '/y' );
  test.identical( got, '/y' );

  //

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '///some/staging/index.html','/something/to/add' );
  test.identical( got, '///something/to/add' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '///some/staging/index.html', 'x', '/something/to/add' );
  test.identical( got, '///something/to/add' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '///some/staging/index.html', 'x', '/something/to/add', 'y' );
  test.identical( got, '///something/to/add/y' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '///some/staging/index.html','/something/to/add', '/y' );
  test.identical( got, '///y' );

  //

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( 'svn+https://user@subversion.com/svn/trunk','/something/to/add' );
  test.identical( got, 'svn+https://user@subversion.com/something/to/add' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/to/add' );
  test.identical( got, 'svn+https://user@subversion.com/something/to/add' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( 'svn+https://user@subversion.com/svn/trunk', 'x', '/something/to/add', 'y' );
  test.identical( got, 'svn+https://user@subversion.com/something/to/add/y' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( 'svn+https://user@subversion.com/svn/trunk','/something/to/add', '/y' );
  test.identical( got, 'svn+https://user@subversion.com/y' );

  //

  var url = 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor';
  var parsed = _.urlParse( url );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( url,'/something/to/add' );
  test.identical( got, parsed.origin + '/something/to/add' + '?query=here&and=here#anchor' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( url, 'x', '/something/to/add' );
  test.identical( got, parsed.origin + '/something/to/add' + '?query=here&and=here#anchor' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( url, 'x', '/something/to/add', 'y' );
  test.identical( got, parsed.origin + '/something/to/add/y' + '?query=here&and=here#anchor' );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( url,'/something/to/add', '/y' );
  test.identical( got, parsed.origin + '/y' + '?query=here&and=here#anchor' );

  //

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( '://some.domain.com/was','/something/to/add' );
  test.identical( got, '://some.domain.com/something/to/add' );

  var url = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.urlJoin( url, 'x'  );
  var expected = '://user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var url = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.urlJoin( url, 'x', '/y'  );
  var expected = '://user:pass@sub.host.com:8080/y?query=string#hash'
  test.identical( got, expected );

  var url = '://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.urlJoin( url, '/x//y//z'  );
  var expected = '://user:pass@sub.host.com:8080/x//y//z?query=string#hash'
  test.identical( got, expected );

  var url = '://user:pass@sub.host.com:8080/p//a//t//h?query=string#hash';
  var got = _.urlJoin( url, 'x/'  );
  var expected = '://user:pass@sub.host.com:8080/p//a//t//h/x?query=string#hash'
  test.identical( got, expected );

  var url = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.urlJoin( url, 'x'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  var url = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.urlJoin( url, 'x', '/y'  );
  var expected = ':///y?query=string#hash'
  test.identical( got, expected );

  var url = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.urlJoin( url, '/x//y//z'  );
  var expected = ':///x//y//z?query=string#hash'
  test.identical( got, expected );

  var url = ':///user:pass@sub.host.com:8080/p/a/t/h?query=string#hash';
  var got = _.urlJoin( url, 'x/'  );
  var expected = ':///user:pass@sub.host.com:8080/p/a/t/h/x?query=string#hash'
  test.identical( got, expected );

  test.description = 'add absolute to url with localPath';
  var got = _.urlJoin( 'file:///some/file','/something/to/add' );
  test.identical( got, 'file:///something/to/add' );

  //

  test.description = 'add urls';

  // var got = _.urlJoin( '//a', '//b', 'c' );
  // test.identical( got, '//b/c' )

  var got = _.urlJoin( 'b://b', 'c://c', 'x' );
  test.identical( got, 'c://c/././x' )

  // var got = _.urlJoin( 'b://b', 'c://c/a', '//x/y' );
  // test.identical( got, '//x/y/a' )

  //

  test.description = 'works like pathJoin';
  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar';
  var got = _.urlJoin.apply( _, paths );
  test.identical( got, expected );

  test.description = 'join unix os paths';
  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo/.';
  var got = _.urlJoin.apply( _, paths );
  test.identical( got, expected );

  test.description = 'more complicated cases'; //

  // var paths = [  '/aa', 'bb//', 'cc' ];
  // var expected = '/aa/bb/cc';
  // var got = _.urlJoin.apply( _, paths );
  // test.identical( got, expected );

  // var paths = [  '/aa', 'bb//', 'cc','.' ];
  // var expected = '/aa/bb/cc/.';
  // var got = _.urlJoin.apply( _, paths );
  // test.identical( got, expected );

  // var paths = [  '/','a', '//b', '././c', '../d', '..e' ];
  // var expected = '//b/a/././c/../d/..e';
  // var got = _.urlJoin.apply( _, paths );
  // test.identical( got, expected );

/*
  _.urlJoin( 'https://some.domain.com/','something/to/add' ) -> 'https://some.domain.com/something/to/add'
  _.urlJoin( 'https://some.domain.com/was','something/to/add' ) -> 'https://some.domain.com/was/something/to/add'
  _.urlJoin( 'https://some.domain.com/was','/something/to/add' ) -> 'https://some.domain.com/something/to/add'

  _.urlJoin( '//some.domain.com/was','/something/to/add' ) -> '//some.domain.com/something/to/add'
  _.urlJoin( '://some.domain.com/was','/something/to/add' ) -> '://some.domain.com/something/to/add'

/some/staging/index.html
//some/staging/index.html
///some/staging/index.html
file:///some/staging/index.html
http://some.come/staging/index.html
svn+https://user@subversion.com/svn/trunk
complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor

*/

}

//

function urlResolve( test )
{
  var pathCurrent = _.strPrependOnce( _.pathCurrent(), '/' );

  var got = _.urlResolve( 'http://www.site.com:13','a' );
  test.identical( got, 'http://www.site.com:13/a' );

  var got = _.urlResolve( 'http://www.site.com:13/','a' );
  test.identical( got, 'http://www.site.com:13/a' );

  var got = _.urlResolve( 'http://www.site.com:13','a', '/b' );
  test.identical( got, 'http://www.site.com:13/b' );

  var got = _.urlResolve( 'http://www.site.com:13','a', '/b', 'c' );
  test.identical( got, 'http://www.site.com:13/b/c' );

  var got = _.urlResolve( 'http://www.site.com:13','/a/', '/b/', 'c/', '.' );
  test.identical( got, 'http://www.site.com:13/b/c' );

  var got = _.urlResolve( 'http://www.site.com:13','a', '.', 'b' );
  test.identical( got, 'http://www.site.com:13/a/b' );

  var got = _.urlResolve( 'http://www.site.com:13/','a', '.', 'b' );
  test.identical( got, 'http://www.site.com:13/a/b' );

  var got = _.urlResolve( 'http://www.site.com:13','a', '..', 'b' );
  test.identical( got, 'http://www.site.com:13/b' );

  var got = _.urlResolve( 'http://www.site.com:13','a', '..', '..', 'b' );
  test.identical( got, 'http://www.site.com:13/../b' );

  var got = _.urlResolve( 'http://www.site.com:13','.a.', 'b','.c.' );
  test.identical( got, 'http://www.site.com:13/.a./b/.c.' );

  var got = _.urlResolve( 'http://www.site.com:13/','.a.', 'b','.c.' );
  test.identical( got, 'http://www.site.com:13/.a./b/.c.' );

  var got = _.urlResolve( 'http://www.site.com:13','a/../' );
  test.identical( got, 'http://www.site.com:13/' );

  var got = _.urlResolve( 'http://www.site.com:13/','a/../' );
  test.identical( got, 'http://www.site.com:13/' );

  //

  var got = _.urlResolve( '://www.site.com:13','a' );
  test.identical( got, '://www.site.com:13/a' );

  var got = _.urlResolve( '://www.site.com:13/','a' );
  test.identical( got, '://www.site.com:13/a' );

  var got = _.urlResolve( '://www.site.com:13','a', '/b' );
  test.identical( got, '://www.site.com:13/b' );

  var got = _.urlResolve( '://www.site.com:13','a', '/b', 'c' );
  test.identical( got, '://www.site.com:13/b/c' );

  var got = _.urlResolve( '://www.site.com:13','/a/', '/b/', 'c/', '.' );
  test.identical( got, '://www.site.com:13/b/c' );

  var got = _.urlResolve( '://www.site.com:13','a', '.', 'b' );
  test.identical( got, '://www.site.com:13/a/b' );

  var got = _.urlResolve( '://www.site.com:13/','a', '.', 'b' );
  test.identical( got, '://www.site.com:13/a/b' );

  var got = _.urlResolve( '://www.site.com:13','a', '..', 'b' );
  test.identical( got, '://www.site.com:13/b' );

  var got = _.urlResolve( '://www.site.com:13','a', '..', '..', 'b' );
  test.identical( got, '://www.site.com:13/../b' );

  var got = _.urlResolve( '://www.site.com:13','.a.', 'b','.c.' );
  test.identical( got, '://www.site.com:13/.a./b/.c.' );

  var got = _.urlResolve( '://www.site.com:13/','.a.', 'b','.c.' );
  test.identical( got, '://www.site.com:13/.a./b/.c.' );

  var got = _.urlResolve( '://www.site.com:13','a/../' );
  test.identical( got, '://www.site.com:13/' );

  var got = _.urlResolve( '://www.site.com:13/','a/../' );
  test.identical( got, '://www.site.com:13/' );

  //

  var got = _.urlResolve( ':///www.site.com:13','a' );
  test.identical( got, ':///www.site.com:13/a' );

  var got = _.urlResolve( ':///www.site.com:13/','a' );
  test.identical( got, ':///www.site.com:13/a' );

  var got = _.urlResolve( ':///www.site.com:13','a', '/b' );
  test.identical( got, ':///b' );

  var got = _.urlResolve( ':///www.site.com:13','a', '/b', 'c' );
  test.identical( got, ':///b/c' );

  var got = _.urlResolve( ':///www.site.com:13','/a/', '/b/', 'c/', '.' );
  test.identical( got, ':///b/c' );

  var got = _.urlResolve( ':///www.site.com:13','a', '.', 'b' );
  test.identical( got, ':///www.site.com:13/a/b' );

  var got = _.urlResolve( ':///www.site.com:13/','a', '.', 'b' );
  test.identical( got, ':///www.site.com:13/a/b' );

  var got = _.urlResolve( ':///www.site.com:13','a', '..', 'b' );
  test.identical( got, ':///www.site.com:13/b' );

  var got = _.urlResolve( ':///www.site.com:13','a', '..', '..', 'b' );
  test.identical( got, ':///b' );

  var got = _.urlResolve( ':///www.site.com:13','.a.', 'b','.c.' );
  test.identical( got, ':///www.site.com:13/.a./b/.c.' );

  var got = _.urlResolve( ':///www.site.com:13/','.a.', 'b','.c.' );
  test.identical( got, ':///www.site.com:13/.a./b/.c.' );

  var got = _.urlResolve( ':///www.site.com:13','a/../' );
  test.identical( got, ':///www.site.com:13' );

  var got = _.urlResolve( ':///www.site.com:13/','a/../' );
  test.identical( got, ':///www.site.com:13' );

  //

  var got = _.urlResolve( '/some/staging/index.html','a' );
  test.identical( got, '/some/staging/index.html/a' );

  var got = _.urlResolve( '/some/staging/index.html','.' );
  test.identical( got, '/some/staging/index.html' );

  var got = _.urlResolve( '/some/staging/index.html/','a' );
  test.identical( got, '/some/staging/index.html/a' );

  var got = _.urlResolve( '/some/staging/index.html','a', '/b' );
  test.identical( got, '/b' );

  var got = _.urlResolve( '/some/staging/index.html','a', '/b', 'c' );
  test.identical( got, '/b/c' );

  var got = _.urlResolve( '/some/staging/index.html','/a/', '/b/', 'c/', '.' );
  test.identical( got, '/b/c' );

  var got = _.urlResolve( '/some/staging/index.html','a', '.', 'b' );
  test.identical( got, '/some/staging/index.html/a/b' );

  var got = _.urlResolve( '/some/staging/index.html/','a', '.', 'b' );
  test.identical( got, '/some/staging/index.html/a/b' );

  var got = _.urlResolve( '/some/staging/index.html','a', '..', 'b' );
  test.identical( got, '/some/staging/index.html/b' );

  var got = _.urlResolve( '/some/staging/index.html','a', '..', '..', 'b' );
  test.identical( got, '/some/staging/b' );

  var got = _.urlResolve( '/some/staging/index.html','.a.', 'b','.c.' );
  test.identical( got, '/some/staging/index.html/.a./b/.c.' );

  var got = _.urlResolve( '/some/staging/index.html/','.a.', 'b','.c.' );
  test.identical( got, '/some/staging/index.html/.a./b/.c.' );

  var got = _.urlResolve( '/some/staging/index.html','a/../' );
  test.identical( got, '/some/staging/index.html' );

  var got = _.urlResolve( '/some/staging/index.html/','a/../' );
  test.identical( got, '/some/staging/index.html' );

  var got = _.urlResolve( '//some/staging/index.html', '.', 'a' );
  test.identical( got, '//some/staging/index.html/a' )

  var got = _.urlResolve( '///some/staging/index.html', 'a', '.', 'b', '..' );
  test.identical( got, '///some/staging/index.html/a' )

  var got = _.urlResolve( 'file:///some/staging/index.html', '../..' );
  test.identical( got, 'file:///some' )

  var got = _.urlResolve( 'svn+https://user@subversion.com/svn/trunk', '../a', 'b', '../c' );
  test.identical( got, 'svn+https://user@subversion.com/svn/a/c' );

  var got = _.urlResolve( 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor', '../../path/name' );
  test.identical( got, 'complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor' )

  var got = _.urlResolve( 'https://web.archive.org/web/*\/http://www.heritage.org/index/ranking', '../../../a.com' );
  test.identical( got, 'https://web.archive.org/web/*\/http://a.com' )

  var got = _.urlResolve( '127.0.0.1:61726', '../path'  );
  test.identical( got, _.pathCurrent() + '/path' )

  var got = _.urlResolve( 'http://127.0.0.1:61726', '../path'  );
  test.identical( got, 'http://127.0.0.1:61726/../path' )

  //

  test.description = 'works like urlResolve';

  var paths = [ 'c:\\', 'foo\\', 'bar\\' ];
  var expected = '/c/foo/bar';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [ '/bar/', '/baz', 'foo/', '.' ];
  var expected = '/baz/foo';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  'aa','.','cc' ];
  var expected = _.pathCurrent() + '/aa/cc';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  'aa','cc','.' ];
  var expected = _.pathCurrent() + '/aa/cc';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '.','aa','cc' ];
  var expected = _.pathCurrent() + '/aa/cc';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '.','aa','cc','..' ];
  var expected = _.pathCurrent() + '/aa';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '.','aa','cc','..','..' ];
  var expected = _.pathCurrent() + '';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  'aa','cc','..','..','..' ]; debugger;
  var expected = _.strCutOffRight( _.pathCurrent(),'/' )[ 0 ]; debugger;
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '.x.','aa','bb','.x.' ];
  var expected = _.pathCurrent() + '/.x./aa/bb/.x.';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '..x..','aa','bb','..x..' ];
  var expected = _.pathCurrent() + '/..x../aa/bb/..x..';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./../a/b' ];
  var expected = '/a/b';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','a/.././a/b' ];
  var expected = '/abc/a/b';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','.././a/b' ];
  var expected = '/a/b';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./.././a/b' ];
  var expected = '/a/b';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./../.' ];
  var expected = '/';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./../../.' ];
  var expected = '/..';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );

  var paths = [  '/abc','./../.' ];
  var expected = '/';
  var got = _.urlResolve.apply( _, paths );
  test.identical( got, expected );
}

//

function urlName( test )
{
  var paths =
  [
    // '',
    'some.txt',
    '/foo/bar/baz.asdf',
    '/foo/bar/.baz',
    '/foo.coffee.md',
    '/foo/bar/baz',
    '/some/staging/index.html',
    '//some/staging/index.html',
    '///some/staging/index.html',
    'file:///some/staging/index.html',
    'http://some.come/staging/index.html',
    'svn+https://user@subversion.com/svn/trunk/index.html',
    'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor',
    '://www.site.com:13/path/name.html?query=here&and=here#anchor',
    ':///www.site.com:13/path/name.html?query=here&and=here#anchor',
  ]

  var expectedExt =
  [
    // '',
    'some.txt',
    'baz.asdf',
    '.baz',
    'foo.coffee.md',
    'baz',
    'index.html',
    'index.html',
    'index.html',
    'index.html',
    'index.html',
    'index.html',
    'name.html',
    'name.html',
    'name.html',
  ]

  var expectedNoExt =
  [
    // '',
    'some',
    'baz',
    '',
    'foo.coffee',
    'baz',
    'index',
    'index',
    'index',
    'index',
    'index',
    'index',
    'name',
    'name',
    'name',
  ]

  test.description = 'urlName works like pathName'
  paths.forEach( ( path, i ) =>
  {
    var got = _.urlName( path );
    var exp = expectedNoExt[ i ];
    test.identical( got, exp );

    var o = { path : path, withExtension : 1 };
    var got = _.urlName( o );
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

  if( !Config.debug )
  return;

  test.description = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.urlName( false );
  });
};

//

//

function urlExt( test )
{
  var paths =
  [
    // '',
    'some.txt',
    '/foo/bar/baz.asdf',
    '/foo/bar/.baz',
    '/foo.coffee.md',
    '/foo/bar/baz',
    '/some/staging/index.html',
    '//some/staging/index.html',
    '///some/staging/index.html',
    'file:///some/staging/index.html',
    'http://some.come/staging/index.html',
    'svn+https://user@subversion.com/svn/trunk/index.html',
    'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor',
    '://www.site.com:13/path/name.html?query=here&and=here#anchor',
    ':///www.site.com:13/path/name.html?query=here&and=here#anchor',
  ]

  var expected =
  [
    // '',
    'txt',
    'asdf',
    '',
    'md',
    '',
    'html',
    'html',
    'html',
    'html',
    'html',
    'html',
    'html',
    'html',
    'html',
  ]

  test.description = 'urlExt test'
  paths.forEach( ( path, i ) =>
  {
    test.logger.log( path )
    var got = _.urlExt( path );
    var exp = expected[ i ];
    test.identical( got, exp );
  })

  if( !Config.debug )
  return;

  test.description = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.urlExt( false );
  });
};

//

function urlChangeExt( test )
{
  var paths =
  [
    { path : 'some.txt', ext : 'abc' },
    { path : '/foo/bar/baz.asdf', ext : 'abc' },
    { path : '/foo/bar/.baz', ext : 'abc' },
    { path : '/foo.coffee.md', ext : 'abc' },
    { path : '/foo/bar/baz', ext : 'abc' },
    { path : '/some/staging/index.html', ext : 'abc' },
    { path : '//some/staging/index.html', ext : 'abc' },
    { path : '///some/staging/index.html', ext : 'abc' },
    { path : 'file:///some/staging/index.html', ext : 'abc' },
    { path : 'http://some.come/staging/index.html', ext : 'abc' },
    { path : 'svn+https://user@subversion.com/svn/trunk/index.html', ext : 'abc' },
    { path : 'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor', ext : 'abc' },
    { path : '://www.site.com:13/path/name.html?query=here&and=here#anchor', ext : 'abc' },
    { path : ':///www.site.com:13/path/name.html?query=here&and=here#anchor', ext : 'abc' },
  ]

  var expected =
  [
    'some.abc',
    '/foo/bar/baz.abc',
    '/foo/bar/.baz.abc',
    '/foo.coffee.abc',
    '/foo/bar/baz.abc',
    '/some/staging/index.abc',
    '//some/staging/index.abc',
    '///some/staging/index.abc',
    'file:///some/staging/index.abc',
    'http://some.come/staging/index.abc',
    'svn+https://user@subversion.com/svn/trunk/index.abc',
    'complex+protocol://www.site.com:13/path/name.abc?query=here&and=here#anchor',
    '://www.site.com:13/path/name.abc?query=here&and=here#anchor',
    ':///www.site.com:13/path/name.abc?query=here&and=here#anchor',
  ]

  test.description = 'urlChangeExt test'
  paths.forEach( ( c, i ) =>
  {
    test.logger.log( c.path, c.ext )
    var got = _.urlChangeExt( c.path, c.ext );
    var exp = expected[ i ];
    test.identical( got, exp );
  })

  if( !Config.debug )
  return;

  test.description = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.urlChangeExt( false );
  });
};

//

function urlDir( test )
{
  var paths =
  [
    'some.txt',
    '/foo/bar/baz.asdf',
    '/foo/bar/.baz',
    '/foo.coffee.md',
    '/foo/bar/baz',
    '/some/staging/index.html',
    '//some/staging/index.html',
    '///some/staging/index.html',
    'file:///some/staging/index.html',
    'http://some.come/staging/index.html',
    'svn+https://user@subversion.com/svn/trunk/index.html',
    'complex+protocol://www.site.com:13/path/name.html?query=here&and=here#anchor',
    '://www.site.com:13/path/name.html?query=here&and=here#anchor',
    ':///www.site.com:13/path/name.html?query=here&and=here#anchor',
  ]

  var expected =
  [
    '.',
    '/foo/bar',
    '/foo/bar',
    '/',
    '/foo/bar',
    '/some/staging',
    '//some/staging',
    '///some/staging',
    'file:///some/staging',
    'http://some.come/staging',
    'svn+https://user@subversion.com/svn/trunk',
    'complex+protocol://www.site.com:13/path?query=here&and=here#anchor',
    '://www.site.com:13/path?query=here&and=here#anchor',
    ':///www.site.com:13/path?query=here&and=here#anchor',
  ]

  test.description = 'urlDir test'
  paths.forEach( ( path, i ) =>
  {
    test.logger.log( path )
    var got = _.urlDir( path );
    var exp = expected[ i ];
    test.identical( got, exp );
  })

  if( !Config.debug )
  return;

  test.description = 'passed argument is non string';
  test.shouldThrowErrorSync( function()
  {
    _.urlDir( false );
  });
};

//

/*

a//b
a///b
127.0.0.1:61726

://some/staging/index.html
:///some/staging/index.html
/some/staging/index.html
file:///some/staging/index.html
http://some.come/staging/index.html
svn+https://user@subversion.com/svn/trunk
complex+protocol://www.site.com:13/path/name?query=here&and=here#anchor
https://web.archive.org/web/*\/http://www.heritage.org/index/ranking
https://user:pass@sub.host.com:8080/p/a/t/h?query=string#hash
*/

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
    urlResolve : urlResolve,

    urlJoin : urlJoin,

    urlName : urlName,
    urlExt : urlExt,
    urlChangeExt : urlChangeExt,
    urlDir : urlDir

  },

};

Self = wTestSuite( Self );

if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self );

} )( );
