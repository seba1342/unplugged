import { NativeModule, requireNativeModule } from "expo";

import { AppRestrictorModuleEvents } from "./AppRestrictor.types";

declare class AppRestrictorModule extends NativeModule<AppRestrictorModuleEvents> {
  authorizationStatus(): Promise<string>;
  requestAuthorization(): Promise<string>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<AppRestrictorModule>("AppRestrictor");
