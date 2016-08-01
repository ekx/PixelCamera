# PixelCamera

PixelCamera is a Unity3D script which was inspired by Ryan Nielson's excellent [PixelCamera2D](https://github.com/RyanNielson/PixelCamera2D). It aims to improved the render quality of pixel art in Unity3D. It does so by rendering to a low resolution render texture. Instead of drawing this render texture to a quad, the render texture is blitted directly to the output of a second camera. It also supports custom upscaling shaders. Two example open source shaders are included under their respective licenses.

## Screenshot

![Screenshot](https://github.com/ekx/PixelCamera/blob/master/Screenshots/Screenshot1.png)

## License

* [MIT](https://github.com/ekx/PixelCamera/blob/master/LICENSE)

## Instructions

* Instantiate the "PixelCamera" prefab in your scene.  
* Optionally you can remove or add shader in the "PixelCamera" script on the game object called "RenderCamera".  
* Use the functions "CycleUsedShader()" and "SetUsedShader(int index)" to switch shaders during runtime.

For a basic setup see the included "Example.unity" scene.

## Acknowledgements

* CRT Shader - (CC BY-NC-SA 3.0) - [Mattias](https://www.shadertoy.com/view/Ms23DR)
* Nearest Neighbour Shader - (MIT) - [jimbo1qaz](http://board.byuu.org/phpbb3/viewtopic.php?f=8&t=523#p11297)
* Example Image - (CC0) - [Buch](http://opengameart.org/content/the-field-of-the-floating-islands)
* Font - (CC0) - [Kenney](http://kenney.nl/assets/kenney-fonts)

## Contributing

Please see the [issues section](https://github.com/ekx/PixelCamera/issues) to
report any bugs or feature requests and to see the list of known issues.

[Pull requests](https://github.com/ekx/PixelCamera/pulls) are always welcome.