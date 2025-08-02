import { StatusBar } from "expo-status-bar";
import { Button, StyleSheet, Text, View } from "react-native";
import AppRestrictor from "./modules/app-restrictor";
import FamilyPickerNativeView from "./modules/app-restrictor/src/FamilyPickerNativeView";
import { useState } from "react";
import ActivityLabelNativeView from "./modules/app-restrictor/src/ActivityLabelNativeView";

export default function App() {
  const [isPickerPresented, setIsPickerPresented] = useState(false);
  const [applicationToken, setApplicationToken] = useState<string | null>(null);

  async function handleRequestPermissions() {
    const result = await AppRestrictor.requestAuthorization();
    console.log(result);
  }

  async function handleGetPermissionsStatus() {
    const result = await AppRestrictor.authorizationStatus();
    console.log(result);
  }

  return (
    <View style={styles.container}>
      <StatusBar style="auto" />
      <FamilyPickerNativeView
        isPickerPresented={isPickerPresented}
        onDismiss={() => {
          console.log("dismissed");
          setIsPickerPresented(false);
        }}
        onSelection={({ nativeEvent }) => {
          setIsPickerPresented(false);
          const selection = JSON.parse(nativeEvent.selection);
          console.log(selection?.applicationTokens?.[0]);

          setApplicationToken(
            JSON.stringify(selection?.applicationTokens?.[0]) ?? ""
          );
        }}
      />
      <Text>Intent</Text>
      <Button title="Request Permissions" onPress={handleRequestPermissions} />
      <Button
        title="Get Permissions Status"
        onPress={handleGetPermissionsStatus}
      />
      <Button title="Select apps" onPress={() => setIsPickerPresented(true)} />

      {applicationToken != null && (
        <ActivityLabelNativeView token={applicationToken} />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
