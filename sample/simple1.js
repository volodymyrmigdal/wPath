
if( typeof module !== 'undefined' )
{
  require( 'wTools' );
  require( 'wPath' );
}

var _ = wTools;

var pathFile = '/a/b/c.x'
var name = _.pathName( pathFile );
console.log( 'name of ' + pathFile + ' is ' + name );
