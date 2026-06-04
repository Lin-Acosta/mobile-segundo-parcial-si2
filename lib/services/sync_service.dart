import 'dart:convert';
import 'package:http/http.dart' as http;
import '../db/database_helper.dart';
import '../models/incidente_local.dart';
import '../config/config.dart';

class SyncService {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<void> syncUnsyncedIncidentes() async {
    final unsynced = await dbHelper.readAllUnsyncedIncidentes();
    if (unsynced.isEmpty) return;

    print('Attempting to sync ${unsynced.length} incidentes...');

    final payload = unsynced.map((e) => {
      'coordenadagps': e.coordenadagps,
      'descripcion': e.descripcion,
      'fecha': e.fecha,
      // The backend will generate ID and vehiculoconductor_id from JWT
    }).toList();

    try {
      final response = await http.post(
        Uri.parse('${Config.apiUrl}/offline-sync/incidentes'),
        headers: {
          'Content-Type': 'application/json',
          // Assuming a token provider here, for demo purposes we just print
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Mark all as synced
        for (var inc in unsynced) {
          if (inc.id != null) {
            await dbHelper.markAsSynced(inc.id!);
          }
        }
        print('Sync successful.');
      } else {
        print('Sync failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Sync failed: $e');
    }
  }
}
