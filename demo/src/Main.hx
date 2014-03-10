﻿package ;

import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.events.Event;

import skeletoraxe.engine.Engine;
import skeletoraxe.atlas.AtlasStorageSkAxe;
import skeletoraxe.atlas.MovieclipSkAxe;

import flash.Lib;

#if (!android && !html5 )
import com.standard.log.alcon.Debug;
#end

/**
 * @author ispebo
 */
class Main extends Engine
{
	public static var STAGE								: Stage;
	private var _animsDefinition						: Array<String> ;
	
	public function new()
	{		
		super();
		STAGE = Lib.current.stage;
		
	#if ( flash ) 
		setDebug();
	#end
	
		
	#if ( android || ios )
		STAGE.addEventListener( Event.DEACTIVATE, pause );
		STAGE.addEventListener( Event.ACTIVATE, resume );
		STAGE.addEventListener( KeyboardEvent.KEY_UP, keyUp );
	#end
		
		setSkeletalAtlas();
		AtlasStorageSkAxe.BUFFER = 30;	
		loadMovie();
	
	}
	
//-------------------------------------------------------------------------------------
	#if ( android || ios )
		private function keyUp( e : KeyboardEvent ) : Void 
		{
			if ( e.keyCode == 27 ) { //Back
				e.stopImmediatePropagation();
				e.stopPropagation();
				Lib.exit();
			}
		}
		
		private function pause( e: Event ) : Void
		{
			pauseEngine();
		}
		
		private function resume( e: Event ) : Void
		{
			playEngine();
		}
	#end
	
	//-------------------------------------------------------------------------------------
#if ( flash )
	//Mise en place du debugger
	private function setDebug() : Void
	{
		Debug.clear();
		Debug.delimiter();
		Debug.mark( 0xff0000 );
		Debug.redirectTrace();
		Debug.monitor( STAGE );
		Debug.enabled = true;
	}
#end
	

//--------------------------------------------------------------------
	//On insère tous les Movieclips en Atlas à charger
	private function setSkeletalAtlas() : Void
	{
		addSkeletalAtlas("xmls/CrazyGator.xml", "gfx/CrazyGator.png");
	
	}
	
	//---------------------------------------------------------------------
	//Tous les Skeletal Atlas on été pris en compte et charges
	override private function loadingFinish() : Void 
	{
		_animsDefinition = [ 
		
						"CrocodileHappy",
						"CrocodileSurprised",
						"CrocodileStones",
						"CrocodileWait",
						"CrocodileWorried"
										
					];
			
										
			
		for ( i in 0 ... 5 ) 
			for ( j in 0 ... 3 )
			 createAnim(  i * 180 + 100, j * 280 + 100 );
			 
	
		start();
					
	
	}
	
	//--------------------------------------------------------------------------
	private function createAnim(  _x: Float, _y: Float ) : Void
	{
		var movie: MovieClip = this.newMovieClip( _animsDefinition[ Std.random(_animsDefinition.length) ] );
		addChild( movie );
		movie.x = _x;
		movie.y = _y;
		enableMovieClip( movie, true  );
		
		movie.addFrameScript( movie.totalFrames - 1, function() 
													{ 
														if ( Std.random(5) == 1 ) 
														{
															movie.addFrameScript( movie.totalFrames - 1, null);
															movie.playing = false;
															
														}
													} );
	}
	
	
	//--------------------------------------------------------------------------
	override private function enterframe( e: Event  ) : Void
	{
		var i : Int = 0;
	
		while ( i < _enableMovies.length )
		{
			var movie: MovieClip = _enableMovies[i];
			if ( !movie.playing )
			{
				enableMovieClip( movie, false  );
				removeChild( movie );
				createAnim( movie.x, movie.y);
			}
			else 
			{
				movie.update();
				i++;
			}
		}
	}

	//---------------------------------------------------------------------------
	
	public static function main() : Void
	{
		var mainInstance: Main = new Main() ;
		Lib.current.stage.addChild( mainInstance );
	}
	
}