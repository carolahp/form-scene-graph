# Form Scene Graph
Hi-DPI renderer for Pharo 12.

### Take into account
This is a beta version, and therefore it is still unstable. Please report new issues as you find them.

### Installing and activating in Pharo

To install, execute the following script in a playground:

```smalltalk
"Scene graph rendering framework"
Metacello new
   baseline: 'FormSceneGraph';
   repository: 'github://carolahp/form-scene-graph';
   onConflictUseIncoming;
   load.
```

To activate, go to settings, check the option `Enable scene graph renderer`, choose `FormSGNewAthensWorldRenderer` from the `Form Scene Graph World Renderer Class` select, and restart the image.

<img width="670" alt="image" src="https://github.com/carolahp/form-scene-graph/assets/4822303/de2cd527-9c3f-42ee-985f-19f32e89bbbe">
