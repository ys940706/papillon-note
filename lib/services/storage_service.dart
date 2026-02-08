import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/surgery.dart';
import '../models/care_task.dart';

class StorageService {
  static const String _surgeriesKey = 'surgeries';
  static const String _careTasksKey = 'care_tasks';

  // ===== Surgery CRUD =====

  Future<List<Surgery>> getSurgeries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_surgeriesKey);
    if (jsonStr == null) return [];

    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => Surgery.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveSurgeries(List<Surgery> surgeries) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(surgeries.map((e) => e.toJson()).toList());
    await prefs.setString(_surgeriesKey, jsonStr);
  }

  Future<void> addSurgery(Surgery surgery) async {
    final surgeries = await getSurgeries();
    surgeries.add(surgery);
    await saveSurgeries(surgeries);
  }

  Future<void> updateSurgery(Surgery surgery) async {
    final surgeries = await getSurgeries();
    final index = surgeries.indexWhere((s) => s.id == surgery.id);
    if (index != -1) {
      surgeries[index] = surgery;
      await saveSurgeries(surgeries);
    }
  }

  Future<void> deleteSurgery(String id) async {
    final surgeries = await getSurgeries();
    surgeries.removeWhere((s) => s.id == id);
    await saveSurgeries(surgeries);
    // 関連するケアタスクも削除
    final tasks = await getCareTasks();
    tasks.removeWhere((t) => t.surgeryId == id);
    await saveCareTasks(tasks);
  }

  // ===== CareTask CRUD =====

  Future<List<CareTask>> getCareTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_careTasksKey);
    if (jsonStr == null) return [];

    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList.map((e) => CareTask.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveCareTasks(List<CareTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(_careTasksKey, jsonStr);
  }

  Future<List<CareTask>> getCareTasksForSurgery(String surgeryId) async {
    final tasks = await getCareTasks();
    return tasks.where((t) => t.surgeryId == surgeryId).toList();
  }

  Future<void> addCareTask(CareTask task) async {
    final tasks = await getCareTasks();
    tasks.add(task);
    await saveCareTasks(tasks);
  }

  Future<void> updateCareTask(CareTask task) async {
    final tasks = await getCareTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveCareTasks(tasks);
    }
  }

  Future<void> deleteCareTask(String id) async {
    final tasks = await getCareTasks();
    tasks.removeWhere((t) => t.id == id);
    await saveCareTasks(tasks);
  }

  // ===== 全データ削除 =====

  Future<void> deleteAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ===== 初回起動フラグ =====

  static const String _onboardingDoneKey = 'onboarding_done';
  static const String _disclaimerAcceptedKey = 'disclaimer_accepted';

  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingDoneKey) ?? false;
  }

  Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingDoneKey, true);
  }

  Future<bool> isDisclaimerAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_disclaimerAcceptedKey) ?? false;
  }

  Future<void> setDisclaimerAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_disclaimerAcceptedKey, true);
  }
}
