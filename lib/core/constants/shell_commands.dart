class ShellCommands {
  // Shizuku & System Package Shell Commands
  static const String listAllPackages = 'pm list packages -f';
  static const String listDisabledPackages = 'pm list packages -d';
  static const String listSystemServices = 'service list';
  
  // Hidden Activity & Component Inspection
  static String getActivityComponents(String packageName) {
    return 'dumpsys package $packageName | grep -A 20 "Activity Resolver Table:"';
  }

  // Network & Process Inspection
  static const String activeNetworkConnections = 'netstat -tulnp';
  static const String runningProcesses = 'ps -A -o PID,NAME,USER,%CPU,%MEM';

  // Permission Inspection
  static String getAppPermissions(String packageName) {
    return 'dumpsys package $packageName | grep "requested permissions:" -A 30';
  }

  // File System & Storage Inspection
  static const String memoryUsageOverview = 'dumpsys meminfo';
  static const String diskSpaceUsage = 'df -h /data /sdcard';
}