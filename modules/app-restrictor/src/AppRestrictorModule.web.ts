import { registerWebModule, NativeModule } from "expo";

import { ChangeEventPayload } from "./AppRestrictor.types";

type AppRestrictorModuleEvents = {
  onChange: (params: ChangeEventPayload) => void;
};

class AppRestrictorModule extends NativeModule<AppRestrictorModuleEvents> {}

export default registerWebModule(AppRestrictorModule, "AppRestrictor");
