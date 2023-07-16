import hilog from '@ohos.hilog';
import testNapi from 'libentry.so'


import common from '@ohos.app.ability.common';
import mediaLibrary from '@ohos.multimedia.mediaLibrary';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  private context = getContext(this) as common.UIAbilityContext;
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            hilog.info(0x0000, 'testTag', 'Test NAPI 2 + 3 = %{public}d', testNapi.add(2, 3));
            this.example();
          })
        Button(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            hilog.info(0x0000, 'testTag', 'Button NAPI 2 + 3 = %{public}d', testNapi.add(222, 3));

            this.context.startAbilityForResult(
              {
                bundleName: "com.ohos.filepicker",
                abilityName: "MainAbility",
                parameters: {
                  'startMode': 'choose', //choose or save
                }
              },
            )
          })
      }
      .width('100%')
    }
    .height('100%')
  }
      async example(){
  const context = getContext(this);
  var media = mediaLibrary.getMediaLibrary(context);
  let DIR_CAMERA = mediaLibrary.DirectoryType.DIR_CAMERA;
  const dicResult = await media.getPublicDirectory(DIR_CAMERA);
  if (dicResult == 'Camera/') {
    console.info('mediaLibraryTest : getPublicDirectory passed '+dicResult);
  } else {
    console.info('mediaLibraryTest : getPublicDirectory failed '+dicResult);
  }
}
}
