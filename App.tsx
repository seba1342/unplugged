import { StatusBar } from "expo-status-bar";
import { Button, StyleSheet, Text, View } from "react-native";
import AppRestrictor from "./modules/app-restrictor";
import FamilyPickerNativeView from "./modules/app-restrictor/src/FamilyPickerNativeView";
import { useState } from "react";

export default function App() {
  const [isPickerPresented, setIsPickerPresented] = useState(false);

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
        onSelection={({ nativeEvent }) => console.log(nativeEvent.selection)}
      />
      <Text>Intent</Text>
      <Button title="Request Permissions" onPress={handleRequestPermissions} />
      <Button
        title="Get Permissions Status"
        onPress={handleGetPermissionsStatus}
      />
      <Button title="Select apps" onPress={() => setIsPickerPresented(true)} />
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
