( function _PathTools_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof wBase === 'undefined' )
  try
  {
    require( '../../Base.s' );
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

// --
// internal
// --

function _filterOnlyPath( e,k,c )
{
  if( _.strIs( k ) )
  {
    if( _.strEnds( k,'Path' ) )
    return true;
    else
    return false
  }
  return _.pathIs( e );
}

//

function _filterOnlyUrl( e,k,c )
{
  if( _.strIs( k ) )
  {
    if( _.strEnds( k,'Url' ) )
    return true;
    else
    return false
  }
  return _.urlIs( e );
}

function _filterNoInnerArray( arr )
{
  return arr.every( ( e ) => !_.arrayIs( e ) );
}

// --
// normalizer
// --

function urlRefine( src )
{

  _.assertWithoutBreakpoint( arguments.length === 1 );
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

var urlsRefine = _.routineInputMultiplicator_functor
({
  routine : urlRefine
});

var urlsOnlyRefine = _.routineInputMultiplicator_functor
({
  routine : urlRefine,
  fieldFilter : _filterOnlyUrl
});

//

function pathRefine( src )
{

  _.assertWithoutBreakpoint( arguments.length === 1 );
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

var pathsRefine = _.routineInputMultiplicator_functor
({
  routine : pathRefine
});

var pathsOnlyRefine = _.routineInputMultiplicator_functor
({
  routine : pathRefine,
  fieldFilter : _filterOnlyPath
});

//

function _pathRegularize( src )
{

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

  return result;
}

//

/**
 * Regularize a path by collapsing redundant delimeters and resolving '..' and '.' segments, so A//B, A/./B and
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
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( src ),'expects string' );

  var result = _._pathRegularize( src );

  _.assert( result.length > 0 );
  _.assert( result === upStr || !_.strEnds( result,upStr ) );
  _.assert( result.lastIndexOf( upStr + hereStr + upStr ) === -1 );
  _.assert( !_.strEnds( result,upStr + hereStr ) );
  if( Config.debug )
  {
    var i = result.lastIndexOf( upStr + downStr + upStr );
    _.assert( i === -1 || !/\w/.test( result.substring( 0,i ) ) );
  }

  return result;
}

//

var pathsRegularize = _.routineInputMultiplicator_functor
({
  routine : pathRegularize
});

var pathsOnlyRegularize = _.routineInputMultiplicator_functor
({
  routine : pathRegularize,
  fieldFilter : _filterOnlyPath,
});

//

// function pathsRegularize( srcs )
// {
//   if( _.strIs( srcs ) )
//   return _.pathRegularize.apply( this,arguments );
//
//   var result = ;
//
//   _.assert( arguments.length === 1 );
//   _.assert( _.strIs( srcs ) || _.arrayIs( srcs ) );
//
//   if( _.strIs( srcs ) )
//   srcs = [ srcs ];
//
//   debugger;
//
//   for( var s = 0 ; s < srcs.length ; s++ )
//   {
//     var src = srcs[ s ];
//     result[ s ] = _.pathRegularize( src );
//   }
//
//   return result;
// }

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

//

var pathsDot = _.routineInputMultiplicator_functor
({
  routine : pathDot
})

var pathsOnlyDot = _.routineInputMultiplicator_functor
({
  routine : pathDot,
  fieldFilter : _filterOnlyPath
})

//

function pathUndot( path )
{
  return _.strRemoveBegin( path, hereThenStr );
}

var pathsUndot = _.routineInputMultiplicator_functor
({
  routine : pathUndot
})

var pathsOnlyUndot = _.routineInputMultiplicator_functor
({
  routine : pathUndot,
  fieldFilter : _filterOnlyPath
})

// --
// path join
// --

/**
 * Joins filesystem paths fragments or urls fragment into one path/url. Uses '/' level delimeter.
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
 * @method _pathJoinAct
 * @memberof wTools
 */

function _pathJoinAct( o )
{
  var result = '';
  var prepending = true;

  /* */

  // _.routineOptions( _pathJoinAct,o );
  _.assert( Object.keys( o ).length === 3 );
  // _.assert( _.arrayLike( o.paths ) );
  _.assert( o.paths.length > 0 );
  // _.assertWithoutBreakpoint( arguments.length === 1 );

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
    _.assert( 0,'pathJoin :','expects strings as path arguments, but #' + a + ' argument is ' + _.strTypeOf( src ) );

    prepending = prepend( src );
    if( prepending === false && !o.url )
    break;

  }

  /* */

  if( result === '' )
  return '.';

  //console.log( '_pathJoinAct',o.paths,'->',result );

  return result;
}

_pathJoinAct.defaults =
{
  paths : null,
  reroot : 0,
  url : 0,
}

//

function _pathsJoinAct( o )
{
  var isArray = false;
  var length = 0;

  /* */

  for( var p = 0 ; p < o.paths.length ; p++ )
  {
    var path = o.paths[ p ];
    if( _.arrayIs( path ) )
    {
      _.assert( _filterNoInnerArray( path ), 'Array must not have inner array( s ).' )

      if( isArray )
      _.assert( path.length === length, 'Arrays must have same length.' );
      else
      {
        length = Math.max( path.length,length );
        isArray = true;
      }
    }
    else
    {
      length = Math.max( 1,length );
    }
  }

  if( isArray === false )
  return _._pathJoinAct( o );

  /* */

  var paths = o.paths;
  function argsFor( i )
  {
    var res = [];
    for( var p = 0 ; p < paths.length ; p++ )
    {
      var path = paths[ p ];
      if( _.arrayIs( path ) )
      res[ p ] = path[ i ];
      else
      res[ p ] = path;
    }
    return res;
  }

  /* */

  // var result = _.entityMake( o.paths );
  var result = new Array( length );
  for( var i = 0 ; i < length ; i++ )
  {
    o.paths = argsFor( i );
    result[ i ] = _._pathJoinAct( o );
  }

  return result;
}

//

/**
 * Method joins all `paths` together, beginning from string that starts with '/', and normalize the resulting path.
 * @example
 * var res = wTools.pathJoin( '/foo', 'bar', 'baz', '.');
 * // '/foo/bar/baz'
 * @param {...string} paths path strings
 * @returns {string} Result path is the concatenation of all `paths` with '/' directory delimeter.
 * @throws {Error} If one of passed arguments is not string
 * @method pathJoin
 * @memberof wTools
 */

function pathJoin()
{

  var result = _pathJoinAct
  ({
    paths : arguments,
    reroot : 0,
    url : 0,
  });

  return result;
}

//

function pathsJoin()
{

  var result = _._pathsJoinAct
  ({
    paths : arguments,
    reroot : 0,
    url : 0,
  });

  return result;
  // var args = arguments;
  // var result = [];
  // var length = 0;
  //
  // /* */
  //
  // for( var a = 0 ; a < arguments.length ; a++ )
  // {
  //   var arg = arguments[ a ];
  //   if( _.arrayIs( arg ) )
  //   length = Math.max( arg.length,length );
  //   else
  //   length = Math.max( 1,length );
  // }
  //
  // /* */
  //
  // function argsFor( i )
  // {
  //   var res = [];
  //   for( var a = 0 ; a < args.length ; a++ )
  //   {
  //     var arg = args[ a ];
  //     if( _.arrayIs( arg ) )
  //     res[ a ] = arg[ i ];
  //     else
  //     res[ a ] = arg;
  //   }
  //   return res;
  // }
  //
  // /* */
  //
  // for( var i = 0 ; i < length ; i++ )
  // {
  //
  //   var paths = argsFor( i );
  //   result[ i ] = _pathJoinAct
  //   ({
  //     paths : paths,
  //     reroot : 0,
  //     url : 0,
  //   });
  //
  // }
  //
  // return result;
}

//

/**
 * Method joins all `paths` strings together.
 * @example
 * var res = wTools.pathReroot( '/foo', '/bar/', 'baz', '.');
 * // '/foo/bar/baz/.'
 * @param {...string} paths path strings
 * @returns {string} Result path is the concatenation of all `paths` with '/' directory delimeter.
 * @throws {Error} If one of passed arguments is not string
 * @method pathReroot
 * @memberof wTools
 */

function pathReroot()
{
  var result = _pathJoinAct
  ({
    paths : arguments,
    reroot : 1,
    url : 0,
  });
  return result;
}

//

function pathsReroot()
{
  var result = _._pathsJoinAct
  ({
    paths : arguments,
    reroot : 1,
    url : 0,
  });

  return result;
}

//

function pathsOnlyReroot()
{
  var result = arguments[ 0 ];
  var length = 0;
  var firstArr = true;

  for( var i = 1; i <= arguments.length - 1; i++ )
  {
    if( _.pathIs( arguments[ i ] ) )
    result = _.pathReroot( result, arguments[ i ] );

    if( _.arrayIs( arguments[ i ]  ) )
    {
      var arr = arguments[ i ];

      if( !firstArr )
      _.assert( length === arr.length );

      for( var j = 0; j < arr.length; j++ )
      {
        if( _.arrayIs( arr[ j ] ) )
        throw _.err( 'Inner arrays are not allowed.' );

        if( _.pathIs( arr[ j ] ) )
        result = _.pathReroot( result, arr[ j ] );
      }

      length = arr.length;
      firstArr = false;
    }
  }

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

function _pathsResolveAct( o )
{
  var paths;

  _.assert( o.paths.length > 0 );

  paths = o.routine.apply( _,o.paths );

  paths = _.arrayAs( paths );

  for( var i = 0; i < paths.length; i++ )
  {
    if( paths[ i ][ 0 ] !== upStr )
    paths[ i ] = _.pathJoin( _.pathCurrent(),paths[ i ] );
  }

  paths = _.pathsRegularize( paths );

  _.assert( paths.length > 0 );

  return paths;
}

//

function pathsResolve()
{
  var result = _pathsResolveAct
  ({
     routine : pathsJoin,
     paths : arguments
  });

  return result;
}

//

function pathsOnlyResolve()
{
  var result = _pathsResolveAct
  ({
     routine : pathsOnlyJoin,
     paths : arguments
  });

  return result;
}

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

  _.assertWithoutBreakpoint( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( path ) , 'pathDir','expects not empty string ( path )' );

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

function _pathSplit( path )
{
  return path.split( upStr );
}

//

function pathSplit( path )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ) )
  var result = _._pathSplit( _.pathRefine( path ) );
  return result;
}

//

var pathsDir = _.routineInputMultiplicator_functor
({
  routine : pathDir
})

//

var pathsOnlyDir = _.routineInputMultiplicator_functor
({
  routine : pathDir,
  fieldFilter : _filterOnlyPath
})

//

/**
 * Returns dirname + filename without extension
 * @example
 * _.pathPrefix( '/foo/bar/baz.ext' ); // '/foo/bar/baz'
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

var pathsPrefix = _.routineInputMultiplicator_functor
({
  routine : pathPrefix
})

var pathsOnlyPrefix = _.routineInputMultiplicator_functor
({
  routine : pathPrefix,
  fieldFilter : _filterOnlyPath
})

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

  _.assertWithoutBreakpoint( arguments.length === 1 );
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

var pathsName = _.routineInputMultiplicator_functor
({
  routine : pathName
})

var pathsOnlyName = _.routineInputMultiplicator_functor
({
  routine : pathName,
  fieldFilter : function( e )
  {
    var path = _.objectIs( e ) ? e.path : e;
    return _.pathIs( path );
  }
})

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

  _.assertWithoutBreakpoint( arguments.length === 1 );
  _.assertWithoutBreakpoint( _.strIs( path ) );

  var name = _.strCutOffRight( path,'/' )[ 2 ] || path;

  var i = name.lastIndexOf( '.' );
  if( i === -1 || i === 0 )
  return path;

  var halfs = _.strCutOffRight( path,'.' );
  return halfs[ 0 ];
}

//

var pathsWithoutExt = _.routineInputMultiplicator_functor
({
  routine : pathWithoutExt
})

var pathsOnlyWithoutExt = _.routineInputMultiplicator_functor
({
  routine : pathWithoutExt,
  fieldFilter : _filterOnlyPath
})

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

function _pathsChangeExt( src )
{
  _.assert( _.arrayLike( src ) );
  _.assert( src.length === 2 );

  return pathChangeExt.apply( this, src );
}

var pathsChangeExt = _.routineInputMultiplicator_functor
({
  routine : _pathsChangeExt
})

var pathsOnlyChangeExt = _.routineInputMultiplicator_functor
({
  routine : _pathsChangeExt,
  fieldFilter : function( e )
  {
    return _.pathIs( e[ 0 ] )
  }
})

//

/**
 * Returns file extension of passed `path` string.
 * If there is no '.' in the last portion of the path returns an empty string.
 * @example
 * _.pathExt( '/foo/bar/baz.ext' ); // 'ext'
 * @param {string} path path string
 * @returns {string} file extension
 * @throws {Error} If passed argument is not string.
 * @method pathExt
 * @memberof wTools
 */

function pathExt( path )
{

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ),'expects path as string' );

  var index = path.lastIndexOf( '/' );
  if( index >= 0 )
  path = path.substr( index+1,path.length-index-1  );

  var index = path.lastIndexOf( '.' );
  if( index === -1 || index === 0 )
  return '';

  index += 1;

  return path.substr( index,path.length-index ).toLowerCase();
}

//

var pathsExt = _.routineInputMultiplicator_functor
({
  routine : pathExt
})

//

var pathsOnlyExt = _.routineInputMultiplicator_functor
({
  routine : pathExt,
  fieldFilter : _filterOnlyPath
})

//

function pathExts( path )
{

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ),'expects path as string' );

  var path = _.pathName({ path : path, withExtension : 1 });

  var exts = path.split( '.' );
  exts.splice( 0,1 );
  exts = _.entityFilter( exts , ( e ) => !e ? undefined : e.toLowerCase() );

  return exts;
}

// --
// path tester
// --

function pathIs( path )
{
  _.assert( arguments.length === 1 );
  return _.strIs( path );
}

//

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

  _.assertWithoutBreakpoint( arguments.length === 1 );
  _.assertWithoutBreakpoint( _.strIs( path ),'expects path as string' );
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

//

function pathIsGlob( src )
{
  if( src.indexOf( '*' ) !== -1 )
  return true;
  return false;
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

  _.assertWithoutBreakpoint( arguments.length === 1 || arguments.length === 2 );

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

function _pathsRelative( o )
{
  _.assert( _.objectIs( o ) || _.arrayLike( o ) );
  var args = _.arrayAs( o );

  return pathRelative.apply( this, args );
}

var pathsRelative = _.routineInputMultiplicator_functor
({
  routine : _pathsRelative
})

function _filterForPathRelative( e )
{
  var paths = [];

  if( _.arrayIs( e ) )
  _.arrayAppendArrays( paths, e );

  if( _.objectIs( e ) )
  _.arrayAppendArrays( paths, [ e.relative, e.path ] );

  if( !paths.length )
  return false;

  return paths.every( ( path ) => _.pathIs( path ) );
}

var pathsOnlyRelative = _.routineInputMultiplicator_functor
({
  routine : _pathsRelative,
  fieldFilter : _filterForPathRelative
})

//

function pathGet( src )
{

  _.assertWithoutBreakpoint( arguments.length === 1 );

  if( _.strIs( src ) )
  return src;
  else throw _.err( 'pathGet : unexpected type of argument : ' + _.strTypeOf( src ) );

}

//

// function pathCommon( src1, src2 )
// {
//   var path1 = _.pathRegularize( src1 );
//   var path2 = _.pathRegularize( src2 );
//
//   console.log( path1, path2 );
//
//   var result = '';
//
//   function common( path1, path2 )
//   {
//     if( path1.length > path2.length )
//     {
//       var temp = path2;
//       path2 = path1;
//       path1 = temp;
//     }
//
//     path1 = _.strSplit( path1, '/' );
//     path2 = _.strSplit( path2, '/' );
//
//     var elem = [];
//     for( var i = 0; i < path1.length; i++ )
//     {
//       if( path1[ i ] === path2[ i ] )
//       elem.push( path1[ i ] );
//       else
//       break
//     }
//     result = elem.join( '/' );
//   }
//
//   if( _.pathIsAbsolute( path1 ) || _.pathIsAbsolute( path2 ) )
//   {
//     if( _.pathIsAbsolute( path1 ) && _.pathIsAbsolute( path2 ) )
//     {
//       if( path1 === path2 )
//       return path1;
//
//       common( path1, path2 );
//       result = '/' + result;
//     }
//     else
//     {
//       if( !_.pathIsAbsolute( path1 ) && _.pathIsAbsolute( path2 ) && path2.length > 1 )
//       throw _.err( "Incompatible path variants" );
//
//       if( !_.pathIsAbsolute( path2 ) && _.pathIsAbsolute( path1 ) && path1.length > 1 )
//       throw _.err( "Incompatible path variants" );
//
//       result = '/';
//     }
//
//   }
//
//   if( !_.pathIsAbsolute( path1 ) && !_.pathIsAbsolute( path2 ) )
//   {
//     if( _.strBegins( path1, downThenStr ) && _.strBegins( path2, downThenStr ) )
//     {
//       var c1 = _.strCount( path1, downThenStr );
//       var c2 = _.strCount( path2, downThenStr );
//
//       path1 = path1.slice( downThenStr.length * c1 );
//       path2 = path2.slice( downThenStr.length * c2 );
//
//       common( path1, path2 );
//
//       // console.log( result );
//
//       var times = c1 - c2 > 0 ? c2 : c1;
//       var prefix = '';
//
//       if( times > 1 )
//       {
//         var prefix = _.arrayFill({ result : [], value : downStr, times : times });
//         prefix = prefix.join( '/' );
//       }
//
//       if( times === 1 )
//       prefix = downThenStr;
//
//       if( result.length )
//       result = prefix + result;
//       else
//       result = prefix;
//
//     }
//     else if( _.strBegins( path1, hereThenStr ) || _.strBegins( path2, hereThenStr ) )
//     {
//       var times = 0;
//       var oneIsDownThenStr = false;
//
//       if( _.strBegins( path1, hereThenStr ) )
//       path1 = _.strRemoveBegin( path1, hereThenStr );
//
//       if( _.strBegins( path2, hereThenStr ) )
//       path2= _.strRemoveBegin( path2, hereThenStr );
//
//       if( _.strBegins( path1, downThenStr ) )
//       {
//         var c1 = times = _.strCount( path1, downThenStr );
//         path1 = path1.slice( downThenStr.length * c1 );
//         oneIsDownThenStr = true;
//       }
//       if( _.strBegins( path2, downThenStr ) )
//       {
//         var c2 = times = _.strCount( path2, downThenStr );
//         path2 = path2.slice( downThenStr.length * c2 );
//         oneIsDownThenStr = true;
//       }
//
//       common( path1, path2 );
//
//       if( !result.length )
//       {
//         if( oneIsDownThenStr )
//         result = downStr;
//         else
//         result = '.';
//
//         return result;
//       }
//
//       if( times > 1 )
//       {
//         var prefix = _.arrayFill({ result : [], value : downStr, times : times });
//         resutl = prefix.join( '/' ) + result;
//       }
//
//       if( times === 1 )
//       result = downThenStr + result;
//     }
//     else
//     {
//       common( path1, path2 );
//
//       if( !result.length )
//       if( _.strBegins( path1, downStr ) || _.strBegins( path2, downStr ) )
//       result = downStr;
//     }
//   }
//
//   return result;
// }

//

function pathCommon( paths )
{
  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( paths ) );

  paths = paths.slice();

  paths.sort( function( a, b )
  {
    return b.length - a.length;
  });

  var result = paths.pop();

  for( var i = 0, len = paths.length; i < len; i++ )
  result = _pathCommon( paths[ i ], result );

  return result;
}

function pathsCommon( paths )
{
  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( paths ) );

  paths = paths.slice();

  var result = _pathsCommonAct
  ({
    paths : paths
  })

  return result;
}

//

function _pathsCommonAct( o )
{
  var isArray = false;
  var length = 0;

  /* */

  for( var p = 0 ; p < o.paths.length ; p++ )
  {
    var path = o.paths[ p ];
    if( _.arrayIs( path ) )
    {
      _.assert( _filterNoInnerArray( path ), 'Array must not have inner array( s ).' )

      if( isArray )
      _.assert( path.length === length, 'Arrays must have same length.' );
      else
      {
        length = Math.max( path.length,length );
        isArray = true;
      }
    }
    else
    {
      length = Math.max( 1,length );
    }
  }

  if( isArray === false )
  return _.pathCommon( o.paths );

  /* */

  var paths = o.paths;
  function argsFor( i )
  {
    var res = [];
    for( var p = 0 ; p < paths.length ; p++ )
    {
      var path = paths[ p ];
      if( _.arrayIs( path ) )
      res[ p ] = path[ i ];
      else
      res[ p ] = path;
    }
    return res;
  }

  /* */

  // var result = _.entityMake( o.paths );
  var result = new Array( length );
  for( var i = 0 ; i < length ; i++ )
  {
    o.paths = argsFor( i );
    result[ i ] = _.pathCommon( o.paths );
  }

  return result;
}

//

function _pathCommon( src1, src2 )
{
  _.assert( arguments.length === 2 );
  _.assert( _.strIs( src1 ) && _.strIs( src2 ) );

  var split = function( src )
  {
    return _.strSplit( { src : src, delimeter : [ '/' ], preservingDelimeters : 1  } );
  }

  // var fill = function( value, times )
  // {
  //   return _.arrayFillTimes( result : [], value : value, times : times } );
  // }

  function getCommon()
  {
    var length = Math.min( first.splitted.length, second.splitted.length );
    for( var i = 0; i < length; i++ )
    {
      if( first.splitted[ i ] === second.splitted[ i ] )
      result.push( first.splitted[ i ] )
      else
      break;
    }
  }

  function parsePath( path )
  {
    var result =
    {
      isRelativeDown : false,
      isRelativeHereThen : false,
      isRelativeHere : false,
      levelsDown : 0
    };

    result.normalized = _.pathRegularize( path );
    result.splitted = split( result.normalized );
    result.isAbsolute = _.pathIsAbsolute( result.normalized );
    result.isRelative = !result.isAbsolute;

    if( result.isRelative )
    if( result.splitted[ 0 ] === downStr )
    {
      result.levelsDown = _.arrayCount( result.splitted, downStr );
      var substr = _.arrayFillTimes( [], result.levelsDown, downStr ).join( '/' );
      var withoutLevels = _.strRemoveBegin( result.normalized, substr );
      result.splitted = split( withoutLevels );
      result.isRelativeDown = true;
    }
    else if( result.splitted[ 0 ] === '.' )
    {
      result.splitted = result.splitted.splice( 2 );
      result.isRelativeHereThen = true;
    }
    else
    result.isRelativeHere = true;

    return result;
  }

  var result = [];
  var first = parsePath( src1 );
  var second = parsePath( src2 );

  var needToSwap = first.isRelative && second.isAbsolute;

  if( needToSwap )
  {
    var tmp = second;
    second = first;
    first = tmp;
  }

  var bothAbsolute = first.isAbsolute && second.isAbsolute;
  var bothRelative = first.isRelative && second.isRelative;
  var absoluteAndRelative = first.isAbsolute && second.isRelative;

  if( absoluteAndRelative )
  {
    if( first.splitted.length > 1 )
    throw _.err( "Incompatible paths." );
    else
    return '/';
  }

  if( bothAbsolute )
  {
    getCommon();

    result = result.join('');

    if( !result.length )
    result = '/';
  }

  if( bothRelative )
  {
    // console.log(  first.splitted, second.splitted );

    if( first.levelsDown === second.levelsDown )
    getCommon();

    result = result.join('');

    var levelsDown = Math.max( first.levelsDown, second.levelsDown );

    if( levelsDown > 0 )
    {
      var prefix = _.arrayFillTimes( [], levelsDown, downStr );
      prefix = prefix.join( '/' );
      result = prefix + result;
    }

    if( !result.length )
    {
      if( first.isRelativeHereThen && second.isRelativeHereThen )
      result = hereStr;
      else
      result = '.';
    }
  }

  if( result.length > 1 )
  if( _.strEnds( result, '/' ) )
  result = result.slice( 0, -1 );

  return result;
}

//

var pathsOnlyCommon = _.routineInputMultiplicator_functor
({
  routine : pathCommon,
  fieldFilter : _filterOnlyPath
})


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

  if( path === undefined )
  path = _global_.location.href;

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
  path = _global_.location.href;

  if( path.indexOf( '//' ) === -1 )
  {
    if( path[ 0 ] === '/' ) return '/';
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

  if( path === undefined )
  path = _global_.location.href;

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
  var query = query || _global_.location.search.split('?')[1];
  if( !query || !query.length ) return result;
  var vars = query.split( '&' );

  for( var i=0 ; i<vars.length ; i++ )
  {

    var w = vars[ i ].split( '=' );
    w[ 0 ] = decodeURIComponent( w[ 0 ] );
    if( w[ 1 ] === undefined ) w[ 1 ] = '';
    else w[ 1 ] = decodeURIComponent( w[ 1 ] );

    if( (w[ 1 ][ 0 ] == w[ 1 ][ w[ 1 ].length-1 ] ) && ( w[ 1 ][ 0 ] == '"') )
    w[ 1 ] = w[ 1 ].substr( 1,w[ 1 ].length-1 );

    if( result[ w[ 0 ] ] === undefined )
    {
      result[ w[ 0 ] ] = w[ 1 ];
    }
    else if( wTools.strIs( result[ w[ 0 ] ] ) )
    {
      result[ w[ 0 ] ] = result[ result[ w[ 0 ] ], w[ 1 ] ]
    }
    else
    {
      result[ w[ 0 ] ].push( w[ 1 ] );
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

  var result = _pathJoinAct
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

var Extend =
{

  // internal

  _filterOnlyPath : _filterOnlyPath,
  _filterOnlyUrl : _filterOnlyUrl,


  // normalizer

  urlRefine : urlRefine,
  urlsRefine : urlsRefine,
  urlsOnlyRefine : urlsOnlyRefine,

  pathRefine : pathRefine,
  pathsRefine : pathsRefine,
  pathsOnlyRefine : pathsOnlyRefine,

  _pathRegularize : _pathRegularize,
  pathRegularize : pathRegularize,
  pathsRegularize : pathsRegularize,
  pathsOnlyRegularize : pathsOnlyRegularize,

  pathDot : pathDot,
  pathsDot : pathsDot,
  pathsOnlyDot : pathsOnlyDot,

  pathUndot : pathUndot,
  pathsUndot : pathsUndot,
  pathsOnlyUndot : pathsOnlyUndot,


  // path join

  _pathJoinAct : _pathJoinAct,
  _pathsJoinAct : _pathsJoinAct,

  pathJoin : pathJoin,
  pathsJoin : pathsJoin,

  pathReroot : pathReroot,
  pathsReroot : pathsReroot,
  pathsOnlyReroot : pathsOnlyReroot,

  pathResolve : pathResolve,
  pathsResolve : pathsResolve,
  pathsOnlyResolve : pathsOnlyResolve,


  // path cut off

  pathSplit : pathSplit,
  _pathSplit : _pathSplit,

  pathDir : pathDir,
  pathsDir : pathsDir,
  pathsOnlyDir : pathsOnlyDir,

  pathPrefix : pathPrefix,
  pathsPrefix : pathsPrefix,
  pathsOnlyPrefix : pathsOnlyPrefix,

  pathName : pathName,
  pathsName : pathsName,
  pathsOnlyName : pathsOnlyName,

  pathWithoutExt : pathWithoutExt,
  pathsWithoutExt : pathsWithoutExt,
  pathsOnlyWithoutExt : pathsOnlyWithoutExt,

  pathChangeExt : pathChangeExt,
  pathsChangeExt : pathsChangeExt,
  pathsOnlyChangeExt : pathsOnlyChangeExt,

  pathExt : pathExt,
  pathsExt : pathsExt,
  pathsOnlyExt : pathsOnlyExt,

  pathExts : pathExts,


  // path tester

  pathIs : pathIs,
  pathIsSafe : pathIsSafe,
  pathIsAbsolute : pathIsAbsolute,
  pathIsRefined : pathIsRefined,
  pathIsGlob : pathIsGlob,


  // path etc

  pathRelative : pathRelative,
  pathsRelative : pathsRelative,
  pathsOnlyRelative : pathsOnlyRelative,

  pathGet : pathGet,

  pathCommon : pathCommon,
  pathsCommon : pathsCommon,
  pathsOnlyCommon : pathsOnlyCommon,


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

}

var Supplement =
{
  pathCurrent : pathCurrent,
}

_.mapExtend( wTools,Extend );
_.mapSupplement( wTools,Supplement );
_.mapExtend( Extend,Supplement );

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Extend;
wTools.path = Extend;

})();