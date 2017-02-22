( function _Path_all_test_s_( ) {

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

  require( './Path.path.test.s' );
  require( './Path.url.test.s' );

}

//

var _ = wTools;

if( typeof module !== 'undefined' && !module.parent )
_.Testing.test();

} )( );
