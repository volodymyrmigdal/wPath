( function _Path_s_() {

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

  _.include( 'wNameTools' );

  var Path = require( 'path' );

}

var Self = wTools;
var _ = wTools;

if( wTools.path )
return;

// --
// normalizer
// --

function urlRefine( src )
{

  _.assertNoDebugger( arguments.length === 1 );
  _.assert( _.strIs( src ) );
  _.assert( _.strIsNotEmpty( src ) );

  if( !src.length )
  debugger;

  if( !src.length )
  return '';

  var result = src.replace( /\\/g,'/' );
  // var result = src.replace( /\/\//g,'/' );

  return result;
}

//

function pathRefine( src )
{

  _.assertNoDebugger( arguments.length === 1 );
  _.assert( _.strIs( src ) );

  if( !src.length )
  return hereStr;

  var result = src;

  if( result[ 1 ] === ':' && ( result[ 2 ] === '\\' || result[ 2 ] === '/' ) )
  result = '/' + result[ 0 ] + '/' + result.substring( 3 );

  result = result.replace( /\\/g,'/' );
  result = result.replace( /\/\//g,'/' );

  /* remove right "/" */
  if( result !== upStr && _.strEnds( result,upStr ) )
  result = _.strRemoveEnd( result,upStr );

  // logger.log( 'pathRefine :',src,'->',result );

  return result;
}

//

/**
 * Regularize a path by collapsing redundant separators and resolving '..' and '.' segments, so A//B, A/./B and
    A/foo/../B all become A/B. This string manipulation may change the meaning of a path that contains symbolic links.
    On Windows, it converts forward slashes to backward slashes. If the path is an empty string, method returns '.'
    representing the current working directory.
 * @example
   var path = '/foo/bar//baz1/baz2//some/..'
   path = wTools.pathRegularize( path ); // /foo/bar/baz1/baz2
 * @param {string} src path for normalization
 * @returns {string}
 * @method pathRegularize
 * @memberof wTools
 */

function pathRegularize( src )
{

  _.assertNoDebugger( arguments.length === 1 );
  _.assert( _.strIs( src ) );

  if( !src.length )
  return '.';

  var result = pathRefine( src );
  var beginsWithHere = src === hereStr || _.strBegins( src,hereThenStr );

  /* remove "." */

  if( result.indexOf( hereStr ) !== -1 )
  {
    while( delHereRegexp.test( result ) )
    result = result.replace( delHereRegexp,upStr );
  }

  if( _.strBegins( result,hereThenStr ) )
  result = _.strRemoveBegin( result,hereThenStr );

  /* remove ".." */

  if( result.indexOf( downStr ) !== -1 )
  {
    while( delDownRegexp.test( result ) )
    result = result.replace( delDownRegexp,upStr );
  }

  /* remove first ".." */

  if( result.indexOf( downStr ) !== -1 )
  {
    while( delDownFirstRegexp.test( result ) )
    result = result.replace( delDownFirstRegexp,'' );
  }

  /* remove right "/" */

  if( result !== upStr && _.strEnds( result,upStr ) )
  result = _.strRemoveEnd( result,upStr );

  /* nothing left */

  if( !result.length )
  result = '.';

  /* get back left "." */

  if( beginsWithHere )
  result = _.pathDot( result );

  // if( src !== result )
  // logger.log( 'pathRegularize :',src,'->',result );

  _.assert( result.length > 0 );
  _.assert( result === upStr || !_.strEnds( result,upStr ) );
  _.assert( result.lastIndexOf( upStr + hereStr + upStr ) === -1 );
  _.assert( !_.strEnds( result,upStr + hereStr ) );
  if( Config.debug )
  {
    var i = result.lastIndexOf( upStr + downStr + upStr );
    _.assert( i === -1 || !/\w/.test( result.substring( 0,i ) ) );
  }

  // if( src.indexOf( 'pro/web/Dave/app/builder/build/../..' ) !== -1 )
  // debugger;

  return result;
}

//

function pathDot( path )
{

  if( path !== hereStr && !_.strBegins( path,hereThenStr ) && path !== downStr && !_.strBegins( path,downThenStr ) )
  {
    _.assert( !_.strBegins( path,upStr ) );
    path = hereThenStr + path;
  }

  return path;
}

// --
// path join
// --

/**
 * Joins filesystem paths fragments or urls fragment into one path/url. Joins always with '/' separator.
 * @param {Object} o join o.
 * @param {String[]} p.paths - Array with paths to join.
 * @param {boolean} [o.url=false] If true, method returns url which consists from joined fragments, beginning
 * from element that contains '//' characters. Else method will join elements in `paths` array as os path names.
 * @param {boolean} [o.reroot=false] If this parameter set to false (by default), method joins all elements in
 * `paths` array, starting from element that begins from '/' character, or '* :', where '*' is any drive name. If it
 * is set to true, method will join all elements in array. Result
 * @returns {string}
 * @private
 * @throws {Error} If missed arguments.
 * @throws {Error} If elements of `paths` are not strings
 * @throws {Error} If o has extra parameters.
 * @method _pathJoin
 * @memberof wTools
 */

function _pathJoin( o )
{
  var result = '';
  var prepending = true;

  /* */

  // _.routineOptions( _pathJoin,o );
  _.assert( Object.keys( o ).length === 3 );
  // _.assert( _.arrayLike( o.paths ) );
  _.assert( o.paths.length > 0 );
  // _.assertNoDebugger( arguments.length === 1 );

  /* */

  function prepend( src )
  {

    _.assert( _.strIs( src ) );

    if( o.url )
    src = _.urlRefine( src );
    else
    src = _.pathRefine( src );

    if( !src )
    return prepending;

    var doPrepend = prepending;
    if( !doPrepend && o.url )
    {
      if( src.indexOf( '//' ) !== -1 )
      {
        var i = src.indexOf( '//' );
        i = src.indexOf( '/',i+2 );
        if( i >= 0 )
        {
          //debugger;
          src = src.substr( 0,i );
        }
        doPrepend = 1;
      }
    }

    if( doPrepend )
    {

      if( !o.url )
      src = src.replace( /\\/g,'/' );

      if( result && src[ src.length-1 ] === '/' )
      if( src.length > 1 || result[ 0 ] === '/' )
      src = src.substr( 0,src.length-1 );

      if( src && src[ src.length-1 ] !== '/' && result && result[ 0 ] !== '/' )
      result = '/' + result;

      result = src + result;

    }

    if( o.url )
    {
      if( src.indexOf( '//' ) !== -1 )
      {
        //debugger;
        //throw _.err( 'not tested' );
        return false;
      }
    }

    if( !o.reroot )
    {
      if( src[ 0 ] === '/' )
      return false;
      if( src[ 1 ] === ':' )
      console.warn( 'WARNING : Path could be native for windows, but should not',src );
      if( src[ 1 ] === ':' )
      debugger;
      // if( src[ 1 ] === ':' )
      // if( src[ 2 ] !== '/' || src[ 3 ] !== '/' )
      // return false;
    }

    return prepending;
  }

  /* */

  for( var a = o.paths.length-1 ; a >= 0 ; a-- )
  {
    var src = o.paths[ a ];

    if( !_.strIs( src ) )
    throw _.err( 'pathJoin :','expects strings as path arguments, but #' + a + ' argument is ' + _.strTypeOf( src ) );

    prepending = prepend( src );
    if( prepending === false && !o.url )
    break;

  }

  /* */

  if( result === '' )
  return '.';

  //console.log( '_pathJoin',o.paths,'->',result );

  return result;
}

_pathJoin.defaults =
{
  paths : null,
  reroot : 0,
  url : 0,
}

//

  /**
   * Method joins all `paths` together, beginning from string that starts with '/', and normalize the resulting path.
   * @example
   * var res = wTools.pathJoin( '/foo', 'bar', 'baz', '.');
   * // '/foo/bar/baz'
   * @param {...string} paths path strings
   * @returns {string} Result path is the concatenation of all `paths` with '/' directory separator.
   * @throws {Error} If one of passed arguments is not string
   * @method pathJoin
   * @memberof wTools
   */

function pathJoin()
{

  var result = _pathJoin
  ({
    paths : arguments,
    reroot : 0,
    url : 0,
  });

  return result;
}

//

/**
 * Method joins all `paths` strings together.
 * @example
 * var res = wTools.pathReroot( '/foo', '/bar/', 'baz', '.');
 * // '/foo/bar/baz/.'
 * @param {...string} paths path strings
 * @returns {string} Result path is the concatenation of all `paths` with '/' directory separator.
 * @throws {Error} If one of passed arguments is not string
 * @method pathReroot
 * @memberof wTools
 */

function pathReroot()
{
  var result = _pathJoin
  ({
    paths : arguments,
    reroot : 1,
    url : 0,
  });
  return result;
}

//

/**
 * Method resolves a sequence of paths or path segments into an absolute path.
 * The given sequence of paths is processed from right to left, with each subsequent path prepended until an absolute
 * path is constructed. If after processing all given path segments an absolute path has not yet been generated,
 * the current working directory is used.
 * @example
 * var absPath = wTools.pathResolve('work/wFiles'); // '/home/user/work/wFiles';
 * @param [...string] paths A sequence of paths or path segments
 * @returns {string}
 * @method pathResolve
 * @memberof wTools
 */

function pathResolve()
{
  var path;

  _.assert( arguments.length > 0 );

  // if( arguments.length <= 1 && !arguments[ 0 ] )
  // path = '.';
  // else
  path = _.pathJoin.apply( _,arguments );

  if( path[ 0 ] !== upStr )
  path = _.pathJoin( _.pathCurrent(),path );

  path = _.pathRegularize( path );

  _.assert( path.length > 0 );

  // var result = Path.resolve.apply( this,arguments );
  // result = _.pathRegularize( result );

  return path;
}

//

var pathsResolve = _.routineInputMultiplicator_functor
({
  routine : pathResolve
});

var pathsOnlyResolve = _.routineInputMultiplicator_functor
({
  routine : pathResolve,
  fieldFilter : function( e,k,c )
  {
    if( !_.strIs( k ) )
    return false;
    if( _.strEnds( k,'Path' ) )
    return true;
  },
});

// function pathsResolve( src )
// {
//
//   _.assert( arguments.length === 1 );
//
//   if( _.strIs( src ) )
//   return _.pathResolve( src );
//
//   if( _.arrayIs( src ) )
//   {
//     var result = [];
//     for( var r = 0 ; r < src.length ; r++ )
//     result[ r ] = _.pathResolve( src[ r ] );
//     return result;
//   }
//
//   if( _.objectIs( src ) )
//   {
//     var result = Object.create( null );
//     for( var r in src )
//     result[ r ] = _.pathResolve( src[ r ] );
//     return result;
//   }
//
//   _.assert( 0,'unknown argument',_.strTypeOf( src ) );
// }

// --
// path cut off
// --

/**
 * Returns the directory name of `path`.
 * @example
 * var path = '/foo/bar/baz/text.txt'
 * wTools.pathDir( path ); // '/foo/bar/baz'
 * @param {string} path path string
 * @returns {string}
 * @throws {Error} If argument is not string
 * @method pathDir
 * @memberof wTools
 */

function pathDir( path )
{

  _.assertNoDebugger( arguments.length === 1 );
  if( !_.strIsNotEmpty( path ) )
  throw _.err( 'pathDir','expects not empty string ( path )' );

  // if( path.length > 1 )
  // if( path[ path.length-1 ] === '/' && path[ path.length-2 ] !== '/' )
  // path = path.substr( 0,path.length-1 )

  path = _.pathRefine( path );

  if( path === rootStr )
  {
    return path + downStr;
  }

  if( _.strEnds( path,upStr + downStr ) || path === downStr )
  {
    return path + upStr + downStr;
  }

  var i = path.lastIndexOf( upStr );

  if( i === -1 )
  {

    if( path === hereStr )
    return downStr;
    else
    return hereStr;

  }

  if( path[ i - 1 ] === '/' )
  return path;

  var result = path.substr( 0,i );

  // _.assert( result.length > 0 );

  if( result === '' )
  result = rootStr;

  return result;
}

//

/**
 * Returns dirname + filename without extension
 * @example
 * wTools.pathExt( '/foo/bar/baz.ext' ); // '/foo/bar/baz'
 * @param {string} path Path string
 * @returns {string}
 * @throws {Error} If passed argument is not string.
 * @method pathPrefix
 * @memberof wTools
 */

function pathPrefix( path )
{

  if( !_.strIs( path ) )
  throw _.err( 'pathPrefix :','expects strings as path' );

  var n = path.lastIndexOf( '/' );
  if( n === -1 ) n = 0;

  var parts = [ path.substr( 0,n ),path.substr( n ) ];

  var n = parts[ 1 ].indexOf( '.' );
  if( n === -1 )
  n = parts[ 1 ].length;

  var result = parts[ 0 ] + parts[ 1 ].substr( 0, n );
  //console.log( 'pathPrefix',path,'->',result );
  return result;
}

//

/**
 * Returns path name (file name).
 * @example
 * wTools.pathName( '/foo/bar/baz.asdf' ); // 'baz'
 * @param {string|object} path|o Path string, or options
 * @param {boolean} o.withExtension if this parameter set to true method return name with extension.
 * @returns {string}
 * @throws {Error} If passed argument is not string
 * @method pathName
 * @memberof wTools
 */

function pathName( o )
{

  if( _.strIs( o ) )
  o = { path : o };

  _.assertNoDebugger( arguments.length === 1 );
  _.routineOptions( pathName,o );
  _.assert( _.strIs( o.path ),'pathName :','expects strings ( o.path )' );

  var i = o.path.lastIndexOf( '/' );
  if( i !== -1 )
  o.path = o.path.substr( i+1 );

  if( !o.withExtension )
  {
    var i = o.path.lastIndexOf( '.' );
    if( i !== -1 ) o.path = o.path.substr( 0,i );
  }

  return o.path;
}

pathName.defaults =
{
  path : null,
  withExtension : 0,
}

//

/**
 * Return path without extension.
 * @example
 * wTools.pathWithoutExt( '/foo/bar/baz.txt' ); // '/foo/bar/baz'
 * @param {string} path String path
 * @returns {string}
 * @throws {Error} If passed argument is not string
 * @method pathWithoutExt
 * @memberof wTools
 */

function pathWithoutExt( path )
{

  _.assertNoDebugger( arguments.length === 1 );
  _.assertNoDebugger( _.strIs( path ) );

  var name = _.strCutOffRight( path,'/' )[ 1 ] || path;

  var i = name.lastIndexOf( '.' );
  if( i === -1 || i === 0 )
  return path;

  var halfs = _.strCutOffRight( path,'.' );
  return halfs[ 0 ];
}

//

/**
 * Replaces existing path extension on passed in `ext` parameter. If path has no extension, adds passed extension
    to path.
 * @example
 * wTools.pathChangeExt( '/foo/bar/baz.txt', 'text' ); // '/foo/bar/baz.text'
 * @param {string} path Path string
 * @param {string} ext
 * @returns {string}
 * @throws {Error} If passed argument is not string
 * @method pathChangeExt
 * @memberof wTools
 */

function pathChangeExt( path,ext )
{

  if( ext === '' )
  return pathWithoutExt( path );
  else
  return pathWithoutExt( path ) + '.' + ext;

}

//

/**
 * Returns file extension of passed `path` string.
 * If there is no '.' in the last portion of the path returns an empty string.
 * @example
 * wTools.pathExt( '/foo/bar/baz.ext' ); // 'ext'
 * @param {string} path path string
 * @returns {string} file extension
 * @throws {Error} If passed argument is not string.
 * @method pathExt
 * @memberof wTools
 */

function pathExt( path )
{

  _.assertNoDebugger( arguments.length === 1 );
  _.assertNoDebugger( _.strIs( path ),'expects path as string' );

  var index = path.lastIndexOf( '/' );
  if( index >= 0 )
  path = path.substr( index+1,path.length-index-1  );

  var index = path.lastIndexOf( '.' );
  if( index === -1 || index === 0 )
  return '';

  index += 1;

  return path.substr( index,path.length-index );
}

// --
// path tester
// --

/**
 * Checks if string is correct possible for current OS path and represent file/directory that is safe for modification
 * (not hidden for example).
 * @param filePath
 * @returns {boolean}
 * @method pathIsSafe
 * @memberof wTools
 */

function pathIsSafe( filePath,concern )
{
  var filePath = _.pathRegularize( filePath );

  if( concern === undefined )
  concern = 2;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( concern >= 2 )
  if( /(^|\/)\.(?!$|\/|\.)/.test( filePath ) )
  return false;

  if( concern >= 1 )
  if( filePath.indexOf( '/' ) === 1 )
  if( filePath[ 0 ] === '/' )
  {
    throw _.err( 'not tested' );
    return false;
  }

  if( concern >= 3 )
  if( /(^|\/)node_modules($|\/)/.test( filePath ) )
  return false;

  if( concern >= 1 )
  {
    var isAbsolute = _.pathIsAbsolute( filePath );
    if( isAbsolute )
    if( _.pathIsAbsolute( filePath ) )
    {
      var level = _.strCount( filePath,upStr );
      if( upStr.indexOf( rootStr ) !== -1 )
      level -= 1;
      if( filePath.split( upStr )[ 1 ].length === 1 )
      level -= 1;
      if( level <= 0 )
      return false;
    }
  }

  // if( safe )
  // safe = filePath.length > 8 || ( filePath[ 0 ] !== '/' && filePath[ 1 ] !== ':' );

  return true;
}

//

function pathIsAbsolute( path )
{

  _.assertNoDebugger( arguments.length === 1 );
  _.assertNoDebugger( _.strIs( path ),'expects path as string' );
  _.assert( path.indexOf( '\\' ) === -1 );

  return _.strBegins( path,upStr );
  // return path[ 0 ] === '/' || path[ 1 ] === ':';
}

//

function pathIsRefined( path )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ),'expects path as string' );

  if( !path.length )
  return false;

  if( path[ 1 ] === ':' && path[ 2 ] === '\\' )
  return false;

  var leftSlash = /\\/g;
  var doubleSlash = /\/\//g;

  if( leftSlash.test( path ) || doubleSlash.test( path ) )
  return false;

  /* check right "/" */
  if( path !== upStr && _.strEnds( path,upStr ) )
  return false;

  return true;
}

// --
// path etc
// --

function pathCurrent()
{
  _.assert( arguments.length === 0 );
  return '.';
}

//

/**
 * Returns a relative path to `path` from an `relative` path. This is a path computation : the filesystem is not
   accessed to confirm the existence or nature of path or start. As second argument method can accept array of paths,
   in this case method returns array of appropriate relative paths. If `relative` and `path` each resolve to the same
   path method returns '.'.
 * @example
 * var pathFrom = '/foo/bar/baz',
   pathsTo =
   [
     '/foo/bar',
     '/foo/bar/baz/dir1',
   ],
   relatives = wTools.pathRelative( pathFrom, pathsTo ); //  [ '..', 'dir1' ]
 * @param {string|wFileRecord} relative start path
 * @param {string|string[]} path path to.
 * @returns {string|string[]}
 * @method pathRelative
 * @memberof wTools
 */

function pathRelative( o )
{

  _.assertNoDebugger( arguments.length === 1 || arguments.length === 2 );

  if( arguments.length === 2 )
  {
    o = { relative : arguments[ 0 ], path : arguments[ 1 ] }
  }

  _.routineOptions( pathRelative, o );

  if( _.arrayIs( o.path ) )
  {
    var result = [];
    var pathRelativeOptions = _.mapExtend( Object.create( null ), o );
    for( var p = 0 ; p < o.path.length ; p++ )
    {
      pathRelativeOptions.path = o.path[ p ];
      result[ p ] = _.pathRelative( pathRelativeOptions );
    }
    return result;
  }

  var relative = _.pathGet( o.relative );
  var path = _.pathGet( o.path );

  _.assert( _.strIs( relative ),'pathRelative expects string ( relative ), but got',_.strTypeOf( relative ) );
  _.assert( _.strIs( path ) || _.arrayIs( path ) );

  if( !o.allowRelative )
  {
    relative = _.pathRegularize( relative );
    path = _.pathRegularize( path );
  }
  else
  {
    relative = _.pathResolve( relative );
    path = _.pathResolve( path );
  }

  _.assert( relative.length > 0 );
  _.assert( path.length > 0 );

  // _.assert( _.strBegins( relative,rootStr ) );
  _.assert( _.pathIsAbsolute( relative ) );
  _.assert( _.pathIsAbsolute( path ) );
  // _.assert( _.strBegins( path,rootStr ) );

  /* */

  var common = _.strCommonLeft( relative,path );

  function goodEnd( s )
  {
    return s.length === common.length || s.substring( common.length,common.length + upStr.length ) === upStr;
  }

  while( common.length > 1 )
  {
    if( !goodEnd( relative ) || !goodEnd( path ) )
    common = common.substring( 0,common.length-1 );
    else break;
  }

  /* */

  if( common === relative )
  {
    if( path === common )
    {
      result = '.';
    }
    else
    {
      result = _.strEndOf( path,common );
      result = _.strRemoveBegin( result,upStr );
    }
  }
  else
  {
    relative = _.strEndOf( relative,common );
    path = _.strEndOf( path,common );
    var count = _.strCount( relative,upStr );
    if( common === upStr )
    count += 1;

    if( _.strBegins( path,upStr ) )
    path = _.strRemoveBegin( path,upStr );

    result = _.strDup( downThenStr,count ) + path;

    if( _.strEnds( result,upStr ) )
    _.assert( result.length > upStr.length );
    result = _.strRemoveEnd( result,upStr );
  }

  // if( relative !== path )
  // logger.log( 'pathRelative :',relative,path,':',result );

  _.assert( result.length > 0 );
  _.assert( !_.strEnds( result,upStr ) );
  _.assert( result.lastIndexOf( upStr + hereStr + upStr ) === -1 );
  _.assert( !_.strEnds( result,upStr + hereStr ) );

  if( Config.debug )
  {
    var i = result.lastIndexOf( upStr + downStr + upStr );
    _.assert( i === -1 || !/\w/.test( result.substring( 0,i ) ) );
  }

  return result;
}

pathRelative.defaults =
{
  relative : null,
  path : null,
  allowRelative : 0
}

//

function pathGet( src )
{

  _.assertNoDebugger( arguments.length === 1 );

  if( _.strIs( src ) )
  return src;
  else throw _.err( 'pathGet : unexpected type of argument : ' + _.strTypeOf( src ) );

}


// --
// url
// --

/**
 *
 * The URL component object.
 * @typedef {Object} UrlComponents
 * @property {string} protocol the URL's protocol scheme.;
 * @property {string} host host portion of the URL;
 * @property {string} port property is the numeric port portion of the URL
 * @property {string} pathname the entire path section of the URL.
 * @property {string} query the entire "query string" portion of the URL, not including '?' character.
 * @property {string} hash property consists of the "fragment identifier" portion of the URL.

 * @property {string} url the whole URL
 * @property {string} hostname host portion of the URL, including the port if specified.
 * @property {string} origin protocol + host + port
 * @private
 */

var _urlComponents =
{

  /* atomic */

  protocol : null,
  host : null,
  port : null,
  pathname : null,
  query : null,
  hash : null,

  /* composite */

  url : null, /* whole */
  hostname : null, /* host + port */
  origin : null, /* protocol + host + port */

}

//

/*
http://www.site.com:13/path/name?query=here&and=here#anchor
2 - protocol
3 - hostname( host + port )
5 - pathname
6 - query
8 - hash
*/

/**
 * Method parses URL string, and returns a UrlComponents object.
 * @example
 *
   var url = 'http://www.site.com:13/path/name?query=here&and=here#anchor'

   wTools.urlParse( url );

   // {
   //   protocol : 'http',
   //   hostname : 'www.site.com:13',
   //   pathname : /path/name,
   //   query : 'query=here&and=here',
   //   hash : 'anchor',
   //   host : 'www.site.com',
   //   port : '13',
   //   origin : 'http://www.site.com:13'
   // }

 * @param {string} path Url to parse
 * @param {Object} o - parse parameters
 * @param {boolean} o.atomicOnly - If this parameter set to true, the `hostname` and `origin` will not be
    included into result
 * @returns {UrlComponents} Result object with parsed url components
 * @throws {Error} If passed `path` parameter is not string
 * @method urlParse
 * @memberof wTools
 */

function urlParse( path, o )
{
  var result = {};
  var parse = new RegExp( '^(?:([^:/\\?#]+):)?(?:\/\/(([^:/\\?#]*)(?::([^/\\?#]*))?))?([^\\?#]*)(?:\\?([^#]*))?(?:#(.*))?$' );
  var o = o || {};

  _.assert( _.strIs( path ) );

  var e = parse.exec( path );
  if( !e )
  throw _.err( 'urlParse :','cant parse :',path );

  result.protocol = e[ 1 ];
  result.hostname = e[ 2 ];
  result.host = e[ 3 ];
  result.port = e[ 4 ];
  result.pathname = e[ 5 ];
  result.query = e[ 6 ];
  result.hash = e[ 7 ];

  if( o.atomicOnly )
  delete result.hostname
  else
  result.origin = result.protocol + '://' + result.hostname;

  return result;
};

urlParse.components = _urlComponents;

//

/**
 * Assembles url string from components
 *
 * @example
 *
   var components =
     {
       protocol : 'http',
       host : 'www.site.com',
       port : '13',
       pathname : '/path/name',
       query : 'query=here&and=here',
       hash : 'anchor',
     };
   wTools.urlMake( UrlComponents );
   // 'http://www.site.com:13/path/name?query=here&and=here#anchor'
 * @param {UrlComponents} components Components for url
 * @returns {string} Complete url string
 * @throws {Error} If `components` is not UrlComponents map
 * @see {@link UrlComponents}
 * @method urlMake
 * @memberof wTools
 */

function urlMake( components )
{
  var result = '';

  _.assertMapHasOnly( components,_urlComponents );

  if( components.url )
  {
    _.assert( _.strIs( components.url ) && components.url );
    return components.url;
  }

  if( _.strIs( components ) )
  return components;
  else if( !_.mapIs( components ) )
  throw _.err( 'unexpected' );

  if( components.origin )
  {
    result += components.origin; // TODO : check fix appropriateness
  }
  else
  {

    if( components.protocol )
    result += components.protocol + ':';

    result += '//';

    if( components.hostname )
    result += components.hostname;
    else
    {
      if( components.host )
      result += components.host;
      else
      result += '127.0.0.1';
      result += ':' + components.port;
    }

  }

  if( components.pathname )
  result = _.urlJoin( result,components.pathname );

  _.assert( !components.query || _.strIs( components.query ) );
  if( components.query )
  result += '?' + components.query;

  if( components.hash )
  result += '#' + components.hash;

  return result;
}

urlMake.components = _urlComponents;

//

/**
 * Complements current window url origin by components passed in o.
 * All components of current origin is replaced by appropriates components from o if they exist.
 * If `o.url` exists and valid, method returns it.
 * @example
 * // current url http://www.site.com:13/foo/baz
   var components =
   {
     pathname : '/path/name',
     query : 'query=here&and=here',
     hash : 'anchor',
   };
   var res = wTools.urlFor(o);
   // 'http://www.site.com:13/path/name?query=here&and=here#anchor'
 *
 * @param {UrlComponents} o o for resolving url
 * @returns {string} composed url
 * @method urlFor
 * @memberof wTools
 */

function urlFor( o )
{

  if( o.url )
  return urlMake( o );

  var url = urlServer();
  var o = _.mapScreens( o,_urlComponents );

  if( !Object.keys( o ).length )
  return url;

  var parsed = urlParse( url,{ atomicOnly : 1 } );

  _.mapExtend( parsed,o );

  return urlMake( parsed );
}

//

/**
 * Returns origin plus path without query part of url string.
 * @example
 *
   var path = 'https ://www.site.com:13/path/name?query=here&and=here#anchor';
   wTools.urlDocument( path, { withoutProtocol : 1 } );
   // 'www.site.com:13/path/name'
 * @param {string} path url string
 * @param {Object} [o] urlDocument o
 * @param {boolean} o.withoutServer if true rejects origin part from result
 * @param {boolean} o.withoutProtocol if true rejects protocol part from result url
 * @returns {string} Return document url.
 * @method urlDocument
 * @memberof wTools
 */

function urlDocument( path,o )
{

  var o = o || {};

  if( path === undefined ) path = window.location.href;

  if( path.indexOf( '//' ) === -1 )
  {
    path = 'http:/' + ( path[0] === '/' ? '' : '/' ) + path;
  }

  var a = path.split( '//' );
  var b = a[ 1 ].split( '?' );

  //

  if( o.withoutServer )
  {
    var i = b[ 0 ].indexOf( '/' );
    if( i === -1 ) i = 0;
    return b[ 0 ].substr( i );
  }
  else
  {
    if( o.withoutProtocol ) return b[0];
    else return a[ 0 ] + '//' + b[ 0 ];
  }

}

//

/**
 * Return origin (protocol + host + port) part of passed `path` string. If missed arguments, returns origin of
 * current document.
 * @example
 *
   var path = 'http://www.site.com:13/path/name?query=here'
   wTools.urlServer( path );
   // 'http://www.site.com:13/'
 * @param {string} [path] url
 * @returns {string} Origin part of url.
 * @method urlServer
 * @memberof wTools
 */

function urlServer( path )
{
  var a,b;

  if( path === undefined )
  path = window.location.href;

  if( path.indexOf( '//' ) === -1 )
  {
    if( path[0] === '/' ) return '/';
    a = [ '',path ]
  }
  else
  {
    a = path.split( '//' );
    a[ 0 ] += '//';
  }

  b = a[ 1 ].split( '/' );

  return a[ 0 ] + b[ 0 ] + '/';
}

//

/**
 * Returns query part of url. If method is called without arguments, it returns current query of current document url.
 * @example
   var url = 'http://www.site.com:13/path/name?query=here&and=here#anchor',
   wTools.urlQuery( url ); // 'query=here&and=here#anchor'
 * @param {string } [path] url
 * @returns {string}
 * @method urlQuery
 * @memberof wTools
 */

function urlQuery( path )
{

  if( path === undefined ) path = window.location.href;

  if( path.indexOf( '?' ) === -1 ) return '';
  return path.split( '?' )[ 1 ];
}

//

/**
 * Parse a query string passed as a 'query' argument. Result is returned as a dictionary.
 * The dictionary keys are the unique query variable names and the values are decoded from url query variable values.
 * @example
 *
   var query = 'k1=&k2=v2%20v3&k3=v4_v4';

   var res = wTools.urlDequery( query );
   // {
   //   k1 : '',
   //   k2 : 'v2 v3',
   //   k3 : 'v4_v4'
   // },

 * @param {string} query query string
 * @returns {Object}
 * @method urlDequery
 * @memberof wTools
 */

function urlDequery( query )
{

  var result = {};
  var query = query || window.location.search.split('?')[1];
  if( !query || !query.length ) return result;
  var vars = query.split("&");
  for( var i=0;i<vars.length;i++ ){

    var w = vars[i].split("=");
    w[0] = decodeURIComponent( w[0] );
    if( w[1] === undefined ) w[1] = '';
    else w[1] = decodeURIComponent( w[1] );

    if( (w[1][0] == w[1][w[1].length-1]) && ( w[1][0] == '"') )
    w[1] = w[1].substr( 1,w[1].length-1 );

    if( result[w[0]] === undefined ) {
      result[w[0]] = w[1];
    } else if( wTools.strIs( result[w[0]] )){
      result[w[0]] = result[result[w[0]], w[1]]
    } else {
      result[w[0]].push(w[1]);
    }

  }

  return result;
}

//

function urlIs( url )
{

  var p =
    '^(https?:\\/\\/)?'                                     // protocol
    + '(\\/)?'                                              // relative
    + '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'    // domain
    + '((\\d{1,3}\\.){3}\\d{1,3}))'                         // ip
    + '(\\:\\d+)?'                                          // port
    + '(\\/[-a-z\\d%_.~+]*)*'                               // path
    + '(\\?[;&a-z\\d%_.~+=-]*)?'                            // query
    + '(\\#[-a-z\\d_]*)?$';                                 // anchor

  var pattern = new RegExp( p,'i' );
  return pattern.test( url );

}

//

function urlJoin()
{

  var result = _pathJoin
  ({
    paths : arguments,
    reroot : 0,
    url : 1,
  });

  return result;
}

// --
// var
// --

var rootStr = '/';
var upStr = '/';
var hereStr = '.';
var hereThenStr = './';
var downStr = '..';
var downThenStr = '../';

var upStrEscaped = _.regexpEscape( upStr );
var butDownUpEscaped = '(?!' + _.regexpEscape( downStr ) + upStrEscaped + ')';
var delDownEscaped = butDownUpEscaped + '((?!' + upStrEscaped + ').)+' + upStrEscaped + _.regexpEscape( downStr ) + '(' + upStrEscaped + '|$)';

var delHereRegexp = new RegExp( upStrEscaped + _.regexpEscape( hereStr ) + '(' + upStrEscaped + '|$)','' );
var delDownRegexp = new RegExp( upStrEscaped + delDownEscaped,'' );
var delDownFirstRegexp = new RegExp( '^' + delDownEscaped,'' );

// --
// prototype
// --

var Proto =
{

  // normalizer

  urlRefine : urlRefine,
  pathRefine : pathRefine,
  pathRegularize : pathRegularize,

  pathDot : pathDot,


  // path join

  _pathJoin : _pathJoin,
  pathJoin : pathJoin,
  pathReroot : pathReroot,
  pathResolve : pathResolve,
  pathsResolve : pathsResolve,
  pathsOnlyResolve : pathsOnlyResolve,


  // path cut off

  pathDir : pathDir,
  pathPrefix : pathPrefix,
  pathName : pathName,
  pathWithoutExt : pathWithoutExt,
  pathChangeExt : pathChangeExt,
  pathExt : pathExt,


  // path tester

  pathIsSafe : pathIsSafe,
  pathIsAbsolute : pathIsAbsolute,
  pathIsRefined : pathIsRefined,


  // path etc

  pathRelative : pathRelative,
  pathCurrent : pathCurrent,
  pathGet : pathGet,


  // url

  urlParse : urlParse,
  urlMake : urlMake,
  urlFor : urlFor,

  urlDocument : urlDocument,
  urlServer : urlServer,
  urlQuery : urlQuery,
  urlDequery : urlDequery,
  urlIs : urlIs,
  urlJoin : urlJoin,


  // var

  _urlComponents : _urlComponents,

};

_.mapExtend( wTools,Proto );
wTools.path = Proto;

// console.log( __dirname,': _Path_s_ : _.pathGet' );
// console.log( _.pathGet );

// export

if( typeof module !== 'undefined' )
{
  module['exports'] = Self;
}

})();
