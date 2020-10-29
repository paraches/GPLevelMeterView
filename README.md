# GPLevelMeterView
GPLevelMeterView is LevelMeterView for iOS

![SampleAppImage](https://github.com/paraches/GPLevelMeterView/blob/images/sampleAppImage.png)

## Environment
- Swift 5
- Xcode 12
- iOS 14

## Usage
Copy GPLevelMeterView.swift in Xcode project.

- use in code

```swift
let meter = GPLevelMeterView(frame: CGRect(x: 0, y: 0, width: 256, height: 32),
                                     orientation: .landscape,
                                     scalePosition: .top,
                                     zeroCenter: false)
self.view.addSubview(meter)
```

- use in Interface Builder

Add View and change its Class to GPLevelMeterView.

![GPLevelMeterViewInIB](https://github.com/paraches/GPLevelMeterView/blob/images/GPLevelMeterViewIB.png)

### Properties
- `orientation`
portrait or landscape.

Default value is landscape.

- `zeroCenter`
Boolean value of meter's 0 position is center or not.

Default value is false.

![scalePosition](https://github.com/paraches/GPLevelMeterView/blob/images/scalePosition.png)

- `meterType`

fill or slice.

Default value is fill.

![typeStdSlice](https://github.com/paraches/GPLevelMeterView/blob/images/typeStdSlice.png)

- `meterColor`

[UIColor]

Default array contain 10 UIColor value. [.red, .red, .red, .yellow, .yellow, .yellow, .yellow, .green, .green, .green]

- `scalePosition`

none, left, top, right, bottom.

Default value is none.

![scalePosition](https://github.com/paraches/GPLevelMeterView/blob/images/scalePosition.png)

- `scaleResolution`

The count of scale grid.

Default value is 10.

![meterScaleResolution](https://github.com/paraches/GPLevelMeterView/blob/images/meterScaleResolution.png)

- `scaleHeight`

The size of scale's short edge.

Default value is 8.

- `barHeight`

The size of level meter's short edge.

Default value is 24.

- `value`

The value of levelMeter which is between -1.0 and 1.0.

## Sample
- YouTube https://youtu.be/XYRHeyBALnQ