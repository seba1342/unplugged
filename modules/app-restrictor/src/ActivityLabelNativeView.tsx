import { requireNativeViewManager } from "expo-modules-core";
import * as React from "react";
import { ViewProps, ViewStyle } from "react-native";

interface ActivityLabelNativeViewProps extends ViewProps {
  token: string;
  style?: ViewStyle;
}

const NativeView: React.ComponentType<
  { tokenJSON: string | null } & ViewProps
> = requireNativeViewManager("AppRestrictor");

export default function ActivityLabelNativeView({
  token,
  style,
}: ActivityLabelNativeViewProps) {
  // const tokenJSON = React.useMemo(() => {
  //   return JSON.stringify({
  //     type: "application", // We know this is an application label
  //     token,
  //   });
  // }, []);

  return <NativeView tokenJSON={JSON.stringify(token)} style={style} />;
}
