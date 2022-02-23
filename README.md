# Form Scene Graph
## Rendering framework inspired on GSK for Pharo.

### Loading the framework in Pharo

For loading this framework with the default software based backend, you need to
execute the following script in a playground:

```smalltalk
"Scene graph rendering framework"
Metacello new
   baseline: 'FormSceneGraph';
   repository: 'github://carolahp/form-scene-graph';
   onConflictUseIncoming;
   load.
```
