( function _PathTools_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      require.resolve( toolsPath );
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

  _.include( 'wNameTools' );

}

var _ = _global_.wTools;

// --
// internal
// --

function _multiplicatorFunctor( o )
{

  if( _.routineIs( o ) || _.strIs( o ) )
  o = { routine : o }

  _.routineOptions( _multiplicatorFunctor,o );
  _.assert( _.routineIs( o.routine ) );
  _.assert( o.fieldNames === null || _.arrayLike( o.fieldNames ) )

  /* */

  var routine = o.routine;
  var fieldNames = o.fieldNames;

  function supplement( src, l )
  {
    if( !_.arrayLike( src ) )
    src = _.arrayFillTimes( [], l, src );
    _.assert( src.length === l, 'routine expects arrays with same length' );
    return src;
  }

  function inputMultiplicator( o )
  {
    var result = [];
    var l = 0;
    var onlyScalars = true;

    if( arguments.length > 1 )
    {
      var args = [].slice.call( arguments );

      for( var i = 0; i < args.length; i++ )
      {
        if( onlyScalars && _.arrayLike( args[ i ] ) )
        onlyScalars = false;

        l = Math.max( l, _.arrayAs( args[ i ] ).length );
      }

      for( var i = 0; i < args.length; i++ )
      args[ i ] = supplement( args[ i ], l );

      for( var i = 0; i < l; i++ )
      {
        var argsForCall = [];

        for( var j = 0; j < args.length; j++ )
        argsForCall.push( args[ j ][ i ] );

        var r = routine.apply( this, argsForCall );
        result.push( r )
      }
    }
    else
    {
      if( fieldNames === null || !_.objectIs( o ) )
      return routine.apply( this, arguments );

      var fields = [];

      for( var i = 0; i < fieldNames.length; i++ )
      {
        var field = o[ fieldNames[ i ] ];

        if( onlyScalars && _.arrayLike( field ) )
        onlyScalars = false;

        l = Math.max( l, _.arrayAs( field ).length );
        fields.push( field );
      }

      for( var i = 0; i < fields.length; i++ )
      fields[ i ] = supplement( fields[ i ], l );

      for( var i = 0; i < l; i++ )
      {
        var options = _.mapExtend( Object.create( null ), o );
        for( var j = 0; j < fieldNames.length; j++ )
        {
          var fieldName = fieldNames[ j ];
          options[ fieldName ] = fields[ j ][ i ];
        }

        result.push( routine( options ) );
      }
    }

    _.assert( result.length === l );

    if( onlyScalars )
    return result[ 0 ];

    return result;
  }

  return inputMultiplicator;
}

_multiplicatorFunctor.defaults =
{
  routine : null,
  fieldNames : null
}

//

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

function pathRefine( src )
{

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( src ) );

  if( !src.length )
  return hereStr;

  var result = src;

  if( result[ 1 ] === ':' && ( result[ 2 ] === '\\' || result[ 2 ] === '/' || result.length === 2 ) )
  result = '/' + result[ 0 ] + '/' + result.substring( 3 );

  result = result.replace( /\\/g,'/' );

  /* remove right "/" */

  if( result !== upStr && !_.strEnds( result, upStr + upStr ))
  result = _.strRemoveEnd( result,upStr );

  // if( result !== upStr )
  // result = result.replace( delUpRegexp, '' );

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

function _pathNormalize( src )
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

  if( _.strBegins( result,hereThenStr ) && !_.strBegins( result, hereThenStr + upStr ) )
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

  if( result !== upStr && !_.strEnds( result, upStr + upStr ) )
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
   path = wTools.pathNormalize( path ); // /foo/bar/baz1/baz2
 * @param {string} src path for normalization
 * @returns {string}
 * @method pathNormalize
 * @memberof wTools
 */

function pathNormalize( src )
{
  _.assert( _.strIs( src ),'expects string' );

  var result = _._pathNormalize( src );

  _.assert( arguments.length === 1 );
  _.assert( result.length > 0 );
  _.assert( result === upStr || _.strEnds( result,upStr + upStr ) ||  !_.strEnds( result,upStr ) );
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

var pathsNormalize = _.routineInputMultiplicator_functor
({
  routine : pathNormalize
});

var pathsOnlyNormalize = _.routineInputMultiplicator_functor
({
  routine : pathNormalize,
  fieldFilter : _filterOnlyPath,
});

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

//

function _pathNativizeWindows( filePath )
{
  var self = this;
  _.assert( _.strIs( filePath ) ) ;
  var result = filePath.replace( /\//g,'\\' );

  if( result[ 0 ] === '\\' )
  if( result.length === 2 || result[ 2 ] === ':' || result[ 2 ] === '\\' )
  result = result[ 1 ] + ':' + result.substring( 2 );

  return result;
}

//

function _pathNativizeUnix( filePath )
{
  var self = this;
  _.assert( _.strIs( filePath ) );
  return filePath;
}

//

var pathNativize;
if( _global_.process && _global_.process.platform === 'win32' )
pathNativize = _pathNativizeWindows;
else
pathNativize = _pathNativizeUnix;

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
  // _.assert( arguments.length === 1 );

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
          src = src.substr( 0,i );
        }
        doPrepend = 1;
      }
    }

    if( doPrepend )
    {

      if( !o.url )
      src = src.replace( /\\/g,'/' );

      if( result && src[ src.length-1 ] === '/' && !_.strEnds( src, '//' ) )
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

var pathsJoin = _multiplicatorFunctor
({
  routine : pathJoin
});

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

  path = _.pathJoin.apply( _,arguments );

  if( path[ 0 ] !== upStr )
  path = _.pathJoin( _.pathCurrent(),path );

  path = _.pathNormalize( path );

  _.assert( path.length > 0 );

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

  paths = _.pathsNormalize( paths );

  _.assert( paths.length > 0 );

  return paths;
}

//

var pathsResolve = _multiplicatorFunctor
({
  routine : pathResolve
})

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

  _.assert( arguments.length === 1 );
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

  _.assert( arguments.length === 1 );
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

function pathNameWithExtension( path )
{

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ),'pathName :','expects strings ( path )' );

  var i = path.lastIndexOf( '/' );
  if( i !== -1 )
  path = path.substr( i+1 );

  return path;
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

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ) );

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

// qqq : extend tests

function pathChangeExt( path,ext )
{

  if( arguments.length === 2 )
  {
    _.assert( _.strIs( ext ) );
  }
  else if( arguments.length === 3 )
  {
    var sub = arguments[ 1 ];
    var ext = arguments[ 2 ];

    _.assert( _.strIs( sub ) );
    _.assert( _.strIs( ext ) );

    var cext = _.pathExt( path );

    if( cext !== sub )
    return path;
  }
  else _.assert( 'Expects 2 or 3 arguments' );

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

function pathLike( path )
{
  _.assert( arguments.length === 1 );
  if( _.pathIs( path ) )
  return true;
  if( _.FileRecord )
  if( path instanceof _.FileRecord )
  return true;
  return false;
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
  var filePath = _.pathNormalize( filePath );

  if( concern === undefined )
  concern = 1;

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.numberIs( concern ) );

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

function pathIsNormalized( path )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ) );
  return _.pathNormalize( path ) === path;
}

//

function pathIsAbsolute( path )
{

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ),'expects path as string' );
  _.assert( path.indexOf( '\\' ) === -1,'expects normalized {-path-}, but got', path );

  return _.strBegins( path,upStr );
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

  if( leftSlash.test( path ) /* || doubleSlash.test( path ) */ )
  return false;

  /* check right "/" */
  if( path !== upStr && !_.strEnds( path,upStr + upStr ) && _.strEnds( path,upStr ) )
  return false;

  return true;
}

//

function pathIsGlob( src )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( src ) );

  var regexp = /(\*\*)|([!?*])|(\[.*\])|(\(.*\))|\{.*\}+(?![^[]*\])/g;
  return regexp.test( src );
}

//

function pathIsDotted( src )
{
  return _.strBegins( path,hereStr );
}

// --
// path transformer
// --

function pathCurrent()
{
  _.assert( arguments.length === 0 );
  return '.';
}

//

function pathGet( src )
{

  _.assert( arguments.length === 1 );

  if( _.strIs( src ) )
  return src;
  else
  _.assert( 0,'pathGet : unexpected type of argument : ' + _.strTypeOf( src ) );

}

var pathsGet = _.routineInputMultiplicator_functor( pathGet );

//

function _pathRelative( o )
{
  var result = '';
  var relative = _.pathGet( o.relative );
  var path = _.pathGet( o.path );

  _.assert( _.strIs( relative ),'pathRelative expects string ( relative ), but got',_.strTypeOf( relative ) );
  _.assert( _.strIs( path ) || _.arrayIs( path ) );

  if( !o.resolving )
  {
    relative = _.pathNormalize( relative );
    path = _.pathNormalize( path );
  }
  else
  {
    relative = _.pathResolve( relative );
    path = _.pathResolve( path );
  }

  if( !_.pathIsAbsolute( relative ) && !_.pathIsAbsolute( path ) )
  {
    relative = _.pathJoin( upStr, relative );
    path = _.pathJoin( upStr, path );
  }

  _.assert( relative.length > 0 );
  _.assert( path.length > 0 );

  _.assert( _.pathIsAbsolute( relative ) );
  _.assert( _.pathIsAbsolute( path ) );

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
      if( !_.strBegins( result,upStr+upStr ) && common !== upStr )
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

    if( !_.strBegins( path,upStr+upStr ) && common !== upStr )
    path = _.strRemoveBegin( path,upStr );

    result = _.strDup( downThenStr,count ) + path;

    if( _.strEnds( result,upStr ) )
    _.assert( result.length > upStr.length );
    result = _.strRemoveEnd( result,upStr );
  }

  if( _.strBegins( result,upStr + upStr ) )
  result = hereStr + result;
  else
  result = _.strRemoveBegin( result,upStr );

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

_pathRelative.defaults =
{
  relative : null,
  path : null,
  resolving : 0
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

  if( arguments[ 1 ] !== undefined )
  {
    o = { relative : arguments[ 0 ], path : arguments[ 1 ] }
  }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routineOptions( pathRelative, o );

  var relative = _.pathGet( o.relative );
  var path = _.pathGet( o.path );

  return _._pathRelative( o );
}

pathRelative.defaults =
{
}

pathRelative.defaults.__proto__ = _pathRelative.defaults;

//

function _pathsRelative( o )
{
  _.assert( _.objectIs( o ) || _.arrayLike( o ) );
  var args = _.arrayAs( o );

  return pathRelative.apply( this, args );
}

var pathsRelative = _multiplicatorFunctor
({
  routine : pathRelative,
  fieldNames : [ 'relative', 'path' ]
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

//

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
      {
        if( first.splitted[ i ] === upStr && first.splitted[ i + 1 ] === upStr )
        break;
        else
        result.push( first.splitted[ i ] );
      }
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

    result.normalized = _.pathNormalize( path );
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
    {
      debugger;
      throw _.err( 'Incompatible paths.' );
    }
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

//

function pathRebase( filePath,oldPath,newPath )
{

  _.assert( arguments.length === 3 );

  filePath = _.pathNormalize( filePath );
  oldPath = _.pathNormalize( oldPath );
  newPath = _.pathNormalize( newPath );

  var commonPath = _.pathCommon([ filePath,oldPath ])

  filePath = _.strRemoveBegin( filePath,commonPath );
  filePath = _.pathReroot( newPath,filePath )

  return filePath;
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
 * @property {string} localPath the entire path section of the URL.
 * @property {string} query the entire "query string" portion of the URL, not including '?' character.
 * @property {string} hash property consists of the "fragment identifier" portion of the URL.

 * @property {string} url the whole URL
 * @property {string} hostWithPort host portion of the URL, including the port if specified.
 * @property {string} origin protocol + host + port
 * @private
 */

var _urlComponents =
{

  /* primitive */

  protocol : null, /* 'svn+http' */
  host : null, /* 'www.site.com' */
  port : null, /* '13' */
  localPath : null, /* '/path/name' */
  query : null, /* 'query=here&and=here' */
  hash : null, /* 'anchor' */

  /* composite */

  protocols : null, /* [ 'svn','http' ] */
  hostWithPort : null, /* 'www.site.com:13' */
  origin : null, /* 'svn+http://www.site.com:13' */
  full : null, /* 'svn+http://www.site.com:13/path/name?query=here&and=here#anchor' */

}

//

/*
http://www.site.com:13/path/name?query=here&and=here#anchor
2 - protocol
3 - hostWithPort( host + port )
5 - localPath
6 - query
8 - hash
*/

function _urlParse( o )
{
  var result = Object.create( null );
  var parse = new RegExp( '^(?:([^:/\\?#]*):)?(?:\/\/(([^:/\\?#]*)(?::([^/\\?#]*))?))?([^\\?#]*)(?:\\?([^#]*))?(?:#(.*))?$' );

  if( _.mapIs( o.srcPath ) )
  {
    _.assertMapHasOnly( o.srcPath,_urlComponents );
    if( o.srcPath.protocols )
    return o.srcPath;
    else if( o.srcPath.full )
    o.srcPath = o.srcPath.full;
    else
    o.srcPath = _.urlStr( o.srcPath );
  }

  _.assert( _.strIs( o.srcPath ) );
  _.assert( arguments.length === 1 );
  _.routineOptions( _urlParse,o );

  var e = parse.exec( o.srcPath );
  if( !e )
  throw _.err( '_urlParse :','cant parse :',o.srcPath );

  if( _.strIs( e[ 1 ] ) )
  result.protocol = e[ 1 ];
  if( _.strIs( e[ 3 ] ) )
  result.host = e[ 3 ];
  if( _.strIs( e[ 4 ] ) )
  result.port = e[ 4 ];
  if( _.strIs( e[ 5 ] ) )
  result.localPath = e[ 5 ];
  if( _.strIs( e[ 6 ] ) )
  result.query = e[ 6 ];
  if( _.strIs( e[ 7 ] ) )
  result.hash = e[ 7 ];

  if( !o.primitiveOnly )
  {
    if( _.strIs( result.protocol ) )
    result.protocols = result.protocol.split( '+' );
    else
    result.protocols = [];
    if( _.strIs( e[ 2 ] ) )
    result.hostWithPort = e[ 2 ];
    if( _.strIs( result.protocol ) || _.strIs( result.hostWithPort ) )
    result.origin = ( _.strIs( result.protocol ) ? result.protocol + '://' : '//' ) + result.hostWithPort;
    result.full = _.urlStr( result );
  }

  return result;
}

_urlParse.defaults =
{
  srcPath : null,
  primitiveOnly : 0,
}

_urlParse.components = _urlComponents;

//

/**
 * Method parses URL string, and returns a UrlComponents object.
 * @example
 *
   var url = 'http://www.site.com:13/path/name?query=here&and=here#anchor'

   wTools.urlParse( url );

   // {
   //   protocol : 'http',
   //   hostWithPort : 'www.site.com:13',
   //   localPath : /path/name,
   //   query : 'query=here&and=here',
   //   hash : 'anchor',
   //   host : 'www.site.com',
   //   port : '13',
   //   origin : 'http://www.site.com:13'
   // }

 * @param {string} path Url to parse
 * @param {Object} o - parse parameters
 * @param {boolean} o.primitiveOnly - If this parameter set to true, the `hostWithPort` and `origin` will not be
    included into result
 * @returns {UrlComponents} Result object with parsed url components
 * @throws {Error} If passed `path` parameter is not string
 * @method urlParse
 * @memberof wTools
 */

function urlParse( srcPath )
{

  var result = this._urlParse
  ({
    srcPath : srcPath,
    primitiveOnly : 0,
  });

  _.assert( arguments.length === 1 );

  return result;
}

urlParse.components = _urlComponents;

//

function urlParsePrimitiveOnly( srcPath )
{
  var result = this._urlParse
  ({
    srcPath : srcPath,
    primitiveOnly : 1,
  });

  _.assert( arguments.length === 1 );

  return result;
}

urlParsePrimitiveOnly.components = _urlComponents;

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
       localPath : '/path/name',
       query : 'query=here&and=here',
       hash : 'anchor',
     };
   wTools.urlStr( UrlComponents );
   // 'http://www.site.com:13/path/name?query=here&and=here#anchor'
 * @param {UrlComponents} components Components for url
 * @returns {string} Complete url string
 * @throws {Error} If `components` is not UrlComponents map
 * @see {@link UrlComponents}
 * @method urlStr
 * @memberof wTools
 */

function urlStr( components )
{
  var result = '';

  _.assert( _.strIs( components ) || _.mapIs( components ) );
  _.assert( arguments.length === 1 );
  _.assertMapHasOnly( components,_urlComponents );
  _.assert( components.url === undefined );

  // result.full += result.origin + _.strPrependOnce( result.localPath,upStr );
  // result.full += ( result.query ? '?' + result.query : '' );
  // result.full += ( result.hash ? '#' + result.hash : '' );

  if( components.full )
  {
    _.assert( _.strIs( components.full ) && components.full );
    return components.full;
  }

  if( _.strIs( components ) )
  return components;

  /* */

  if( components.origin )
  {
    result += components.origin;
  }
  else
  {
    // if( components.protocol !== undefined && components.protocol !== null )
    // result += components.protocol + ':';

    var hostWithPort;
    if( components.hostWithPort )
    {
      hostWithPort = components.hostWithPort;
    }
    else
    {
      if( components.host !== undefined )
      hostWithPort = components.host;
      else if( components.port !== undefined && components.port !== null )
      hostWithPort += '127.0.0.1';
      if( components.port !== undefined && components.port !== null )
      hostWithPort += ':' + components.port;
    }

    // if( result || hostWithPort )
    // result += '//';
    // result += hostWithPort;

    if( _.strIs( components.protocol ) || _.strIs( hostWithPort ) )
    result += ( _.strIs( components.protocol ) ? components.protocol + '://' : '//' ) + hostWithPort;

  }

  /* */

  if( components.localPath )
  result += _.strPrependOnce( components.localPath,upStr );

  // result.full += ( result.query ? '?' + result.query : '' );
  // result.full += ( result.hash ? '#' + result.hash : '' );
  //
  // if( components.localPath )
  // result = _.urlJoin( result,components.localPath );

  _.assert( !components.query || _.strIs( components.query ) );

  if( components.query !== undefined )
  result += '?' + components.query;

  if( components.hash !== undefined )
  result += '#' + components.hash;

  return result;
}

urlStr.components = _urlComponents;

  // protocol : null, /* 'svn+http' */
  // host : null, /* 'www.site.com' */
  // port : null, /* '13' */
  // localPath : null, /* '/path/name' */
  // query : null, /* 'query=here&and=here' */
  // hash : null, /* 'anchor' */
  //
  //
  // protocols : null, /* [ 'svn','http' ] */
  // hostWithPort : null, /* 'www.site.com:13' */
  // origin : null, /* 'svn+http://www.site.com:13' */
  // full : null, /* 'svn+http://www.site.com:13/path/name?query=here&and=here#anchor' */

//

/**
 * Complements current window url origin by components passed in o.
 * All components of current origin is replaced by appropriates components from o if they exist.
 * If { o.full } exists and valid, method returns it.
 * @example
 * // current url http://www.site.com:13/foo/baz
   var components =
   {
     localPath : '/path/name',
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

  if( o.full )
  return urlStr( o );

  _.assertMapHasOnly( o,_urlComponents )

  var url = urlServer();
  var o = _.mapScreens( o,_urlComponents );

  // if( !Object.keys( o ).length )
  // return url;

  var parsed = this.urlParsePrimitiveOnly( url );

  _.mapExtend( parsed,o );

  return urlStr( parsed );
}

//

function urlRefine( fileUrl )
{

  _.assert( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( fileUrl ) );

  if( this.urlIsGlobal( fileUrl ) )
  fileUrl = this.urlParsePrimitiveOnly( fileUrl );
  else
  return _.pathRefine( fileUrl );

  if( _.strIsNotEmpty( fileUrl.localPath ) )
  fileUrl.localPath = _.pathRefine( fileUrl.localPath );

  return this.urlStr( fileUrl );

  // throw _.err( 'deprecated' );
  //
  // if( !src.length )
  // debugger;
  //
  // if( !src.length )
  // return '';
  //
  // var result = src.replace( /\\/g,'/' );
  //
  // return result;
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

function urlNormalize( fileUrl )
{
  if( _.strIs( fileUrl ) )
  {
    if( _.urlIsGlobal( fileUrl ) )
    fileUrl = _.urlParsePrimitiveOnly( fileUrl );
    else
    return _.pathNormalize( fileUrl );
  }
  _.assert( fileUrl );
  fileUrl.localPath = _.pathNormalize( fileUrl.localPath );
  return _.urlStr( fileUrl );
}

//

var urlsNormalize = _.routineInputMultiplicator_functor
({
  routine : urlNormalize
});

//

var urlsOnlyNormalize = _.routineInputMultiplicator_functor
({
  routine : urlNormalize,
  fieldFilter : _filterOnlyPath,
});

//

function urlJoin()
{
  var result = Object.create( null );
  var srcs = [];

  var parsed = false;

  for( var s = 0 ; s < arguments.length ; s++ )
  {
    if( _.urlIsGlobal( arguments[ s ] ) )
    {
      parsed = true;
      srcs[ s ] = _.urlParsePrimitiveOnly( arguments[ s ] );
    }
    else
    {
      srcs[ s ] = { localPath : arguments[ s ] };
    }
  }

  for( var s = srcs.length-1 ; s >= 0 ; s-- )
  {
    var src = srcs[ s ];

    if( result.protocol && src.protocol )
    if( result.protocol !== src.protocol )
    continue;

    if( !result.protocol && src.protocol !== undefined )
    result.protocol = src.protocol;

    var hostWas = result.host;
    if( !result.host && src.host !== undefined )
    // if( !result.port || !src.port || result.port === src.port )
    result.host = src.host;

    if( !result.port && src.port !== undefined )
    if( !hostWas || !src.host || hostWas === src.host )
    result.port = src.port;

    if( !result.localPath && src.localPath !== undefined )
    result.localPath = src.localPath;
    else if( src.localPath )
    result.localPath = _.pathJoin( src.localPath,result.localPath );

    if( src.query !== undefined )
    if( !result.query )
    result.query = src.query;
    else
    result.query += '&' + src.query;

    if( !result.hash && src.hash !==undefined )
    result.hash = src.hash;

  }

  if( !parsed )
  return result.localPath;

  return _.urlStr( result );
}

//

var urlsJoin = _multiplicatorFunctor
({
  routine : urlJoin
});


//

function urlResolve()
{
  var result = Object.create( null );
  var srcs = [];

  var parsed = false;

  for( var s = 0 ; s < arguments.length ; s++ )
  {
    if( _.urlIsGlobal( arguments[ s ] ) )
    {
      parsed = true;
      srcs[ s ] = _.urlParsePrimitiveOnly( arguments[ s ] );
    }
    else
    {
      srcs[ s ] = { localPath : arguments[ s ] };
    }
  }

  for( var s = 0 ; s < srcs.length ; s++ )
  {
    var src = srcs[ s ];

    if( !result.protocol && src.protocol !== undefined )
    result.protocol = src.protocol;

    if( !result.host && src.host !== undefined )
    result.host = src.host;

    if( !result.port && src.port !== undefined )
    result.port = src.port;

    if( !result.localPath && src.localPath !== undefined )
    {
      if( !_.strIsNotEmpty( src.localPath ) )
      src.localPath = rootStr;

      result.localPath = src.localPath;
    }
    else
    {
      result.localPath = _.pathResolve( result.localPath, src.localPath );
    }

    if( src.query !== undefined )
    if( !result.query )
    result.query = src.query;
    else
    result.query += '&' + src.query;

    if( !result.hash && src.hash !==undefined )
    result.hash = src.hash;

  }

  if( !parsed )
  return result.localPath;

  return _.urlStr( result );
}

//

function urlRelative( o )
{

  if( arguments[ 1 ] !== undefined )
  {
    o = { relative : arguments[ 0 ], path : arguments[ 1 ] }
  }

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.routineOptions( _._pathRelative, o );

  if( !_.urlIsGlobal( o.relative ) && !_.urlIsGlobal( o.path ) )
  return _._pathRelative( o );

  var relative = this.urlParse( o.relative );
  var path = this.urlParse( o.path );

  var optionsForPath = _.mapExtend( null,o );
  optionsForPath.relative = relative.localPath;
  optionsForPath.path = path.localPath;

  relative.localPath = _._pathRelative( optionsForPath );

  return _.urlStr( relative );
}

urlRelative.defaults =
{
}

urlRelative.defaults.__proto__ = _pathRelative.defaults;

//

function urlCommon( urls )
{
  _.assert( arguments.length === 1 );
  _.assert( _.arrayLike( urls ) );

  var _urls = urls.slice();

  _urls.sort( function( a, b )
  {
    return b.length - a.length;
  });

  var onlyLocals = true;

  function parse( url )
  {
    var result;

    if( _.urlIsGlobal( url ) )
    {
      result = _.urlParse( url );
      onlyLocals = false;
    }
    else
    {
      result = { localPath : url };
    }

    return result;
  }

  var result = parse( _urls.pop() );

  for( var i = 0, len = _urls.length; i < len; i++ )
  {
    var currentUrl = parse( _urls[ i ] );

    if( result.protocol !== currentUrl.protocol || result.port !== currentUrl.port || result.host !== currentUrl.host )
    {
      result = '';
      return result;
    }

    result.localPath = _pathCommon( currentUrl.localPath, result.localPath );
  }

  if( onlyLocals )
  return result.localPath;

  result.full = null;
  result.origin = null;

  return _.urlStr( result );
}

//

function urlName( o )
{
  if( _.strIs( o ) )
  o = { path : o }

  _.assert( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( o.path ) );
  _.routineOptions( urlName, o );

  if( !_.urlIsGlobal( o.path ) )
  return _.pathName( o );

  var path = this.urlParse( o.path );

  var optionsForName = _.mapExtend( null,o );
  optionsForName.path = path.localPath;
  return _.pathName( optionsForName );
}

urlName.defaults = {};
urlName.defaults.__proto__ = pathName.defaults;

//

function urlExt( path )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( path ) );

  if( _.urlIsGlobal( path ) )
  path = this.urlParse( path ).localPath;

  return _.pathExt( path );
}

//

function urlExts( path )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( path ) );

  if( _.urlIsGlobal( path ) )
  path = this.urlParse( path ).localPath;

  return _.pathExts( path );
}

//

function urlChangeExt( path, ext )
{
  _.assert( arguments.length === 2 );
  _.assert( _.strIsNotEmpty( path ) );
  _.assert( _.strIs( ext ) );

  if( !_.urlIsGlobal( path ) )
  return _.pathChangeExt( path, ext );

  var path = this.urlParse( path );
  path.localPath = _.pathChangeExt( path.localPath, ext );

  path.full = null;
  path.origin = null;

  return _.urlStr( path );
}

//

function urlDir( path )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( path ) );

  if( !_.urlIsGlobal( path ) )
  return _.pathDir( path );

  var path = this.urlParse( path );
  path.localPath = _.pathDir( path.localPath );

  path.full = null;
  path.origin = null;

  return _.urlStr( path );
}

//

/**
 * Returns origin plus path without query part of url string.
 * @example
 *
   var path = 'https://www.site.com:13/path/name?query=here&and=here#anchor';
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
  var o = o || Object.create( null );

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

  var result = Object.create( null );
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
    else if( _.strIs( result[ w[ 0 ] ] ) )
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

// --
// url tester
// --

  // '^(https?:\\/\\/)?'                                     // protocol
  // + '(\\/)?'                                              // relative
  // + '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'    // domain
  // + '((\\d{1,3}\\.){3}\\d{1,3}))'                         // ip
  // + '(\\:\\d+)?'                                          // port
  // + '(\\/[-a-z\\d%_.~+]*)*'                               // path
  // + '(\\?[;&a-z\\d%_.~+=-]*)?'                            // query
  // + '(\\#[-a-z\\d_]*)?$';                                 // anchor

var urlIsRegExpString =
  '^([\w\d]*:\\/\\/)?'                                    // protocol
  + '(\\/)?'                                              // relative
  + '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'    // domain
  + '((\\d{1,3}\\.){3}\\d{1,3}))'                         // ip
  + '(\\:\\d+)?'                                          // port
  + '(\\/[-a-z\\d%_.~+]*)*'                               // path
  + '(\\?[;&a-z\\d%_.~+=-]*)?'                            // query
  + '(\\#[-a-z\\d_]*)?$';                                 // anchor

var urlIsRegExp = new RegExp( urlIsRegExpString,'i' );
function urlIs( url )
{
  _.assert( arguments.length === 1 );
  return _.strIs( path );
}

//

function urlIsGlobal( fileUrl )
{
  _.assert( _.strIs( fileUrl ) );
  return _.strHas( fileUrl,'://' );
}

//

function urlIsSafe( path )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( path ) );

  if( _.urlIsGlobal( path ) )
  path = this.urlParse( path ).localPath;

  return _.pathIsSafe( path );
}

//

function urlIsNormalized( path )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( path ) );
  return _.urlNormalize( path ) === path;
}

//

function urlIsAbsolute( path )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strIsNotEmpty( path ) );

  if( _.urlIsGlobal( path ) )
  path = this.urlParse( path ).localPath;

  return _.pathIsAbsolute( path );
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
var delDownEscaped2 = butDownUpEscaped + '((?!' + upStrEscaped + ').|)+' + upStrEscaped + _.regexpEscape( downStr ) + '(' + upStrEscaped + '|$)';
var delUpRegexp = new RegExp( upStrEscaped + '+$' );
var delHereRegexp = new RegExp( upStrEscaped + _.regexpEscape( hereStr ) + '(' + upStrEscaped + '|$)','' );
var delDownRegexp = new RegExp( upStrEscaped + delDownEscaped2,'' );
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

  pathRefine : pathRefine,
  pathsRefine : pathsRefine,
  pathsOnlyRefine : pathsOnlyRefine,

  _pathNormalize : _pathNormalize,
  pathNormalize : pathNormalize,
  pathsNormalize : pathsNormalize,
  pathsOnlyNormalize : pathsOnlyNormalize,

  pathDot : pathDot,
  pathsDot : pathsDot,
  pathsOnlyDot : pathsOnlyDot,

  pathUndot : pathUndot,
  pathsUndot : pathsUndot,
  pathsOnlyUndot : pathsOnlyUndot,

  _pathNativizeWindows : _pathNativizeWindows,
  _pathNativizeUnix : _pathNativizeUnix,
  pathNativize : pathNativize,


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

  pathNameWithExtension : pathNameWithExtension,

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
  pathLike : pathLike,
  pathIsSafe : pathIsSafe,
  pathIsNormalized : pathIsNormalized,
  pathIsAbsolute : pathIsAbsolute,
  pathIsRefined : pathIsRefined,
  pathIsGlob : pathIsGlob,
  pathIsDotted : pathIsDotted,


  // path transformer

  pathGet : pathGet,
  pathsGet : pathsGet,

  _pathRelative : _pathRelative,
  pathRelative : pathRelative,
  pathsRelative : pathsRelative,
  pathsOnlyRelative : pathsOnlyRelative,

  pathCommon : pathCommon,
  pathsCommon : pathsCommon,
  pathsOnlyCommon : pathsOnlyCommon,

  pathRebase : pathRebase,


  // url

  _urlParse : _urlParse,
  urlParse : urlParse,
  urlParsePrimitiveOnly : urlParsePrimitiveOnly,

  urlStr : urlStr,
  urlFor : urlFor,

  urlRefine : urlRefine,
  urlsRefine : urlsRefine,
  urlsOnlyRefine : urlsOnlyRefine,

  urlNormalize : urlNormalize,
  urlsNormalize : urlsNormalize,
  urlsOnlyNormalize : urlsOnlyNormalize,

  urlJoin : urlJoin,
  urlsJoin : urlsJoin,

  urlResolve : urlResolve,
  urlRelative : urlRelative,
  urlCommon : urlCommon,
  urlName : urlName,
  urlExt : urlExt,
  urlExts : urlExts,
  urlChangeExt : urlChangeExt,
  urlDir : urlDir,

  urlDocument : urlDocument,
  urlServer : urlServer,
  urlQuery : urlQuery,
  urlDequery : urlDequery,


  // url tester

  urlIs : urlIs,
  urlIsGlobal : urlIsGlobal,
  urlIsSafe : urlIsSafe,
  urlIsNormalized : urlIsNormalized,
  urlIsAbsolute : urlIsAbsolute,


  // var

  _urlComponents : _urlComponents,

}

var Supplement =
{
  pathCurrent : pathCurrent,
}

_.mapExtend( _,Extend );
_.mapSupplement( _,Supplement );

if( _.path )
{
  _.mapExtend( _.path,Extend );
  _.mapSupplement( _.path,Supplement );
}
else
{
  _.path = Extend;
}

var Self = _.mapExtend( Extend,Supplement );

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_._UsingWtoolsPrivately_ )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
