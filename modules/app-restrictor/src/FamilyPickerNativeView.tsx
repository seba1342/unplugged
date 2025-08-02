import { requireNativeViewManager } from "expo-modules-core";
import * as React from "react";
import { ViewProps } from "react-native";

export type FamilyPickerNativeViewProps = ViewProps & {
  /**
   * A boolean to control whether the native FamilyActivityPicker is presented.
   */
  isPickerPresented: boolean;
  /**
   * A callback event that the native view will call when the user makes a selection.
   * The event contains the selection data as a JSON string.
   */
  onSelection: (event: { nativeEvent: { selection: string } }) => void;
};

// This line gets a reference to the native view manager that Expo creates
// for your module. The name is automatically generated as "YourModuleNameView".
const NativeView: React.ComponentType<FamilyPickerNativeViewProps> =
  requireNativeViewManager("AppRestrictor_FamilyActivityPickerView");

/**
 * A React component that wraps the native FamilyActivityPicker view. Used for
 * displaying the apps you can block on iOS.
 */
export default function FamilyPickerNativeView(
  props: FamilyPickerNativeViewProps
) {
  return <NativeView {...props} />;
}
