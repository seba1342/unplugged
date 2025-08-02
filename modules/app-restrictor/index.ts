// Reexport the native module. On web, it will be resolved to AppRestrictorModule.web.ts
// and on native platforms to AppRestrictorModule.ts
export { default } from "./src/AppRestrictorModule";
export * from "./src/AppRestrictor.types";
