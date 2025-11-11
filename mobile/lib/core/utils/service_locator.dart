import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../features/emergency/data/datasources/emergency_remote_datasource.dart';
import '../../features/emergency/data/datasources/emergency_local_datasource.dart';
import '../../features/emergency/data/repositories/emergency_repository_impl.dart';
import '../../features/emergency/domain/repositories/emergency_repository.dart';
import '../../features/emergency/domain/usecases/trigger_emergency.dart';
import '../../features/emergency/domain/usecases/cancel_emergency.dart';
import '../../features/emergency/domain/usecases/get_current_location.dart';
import '../../features/emergency/presentation/bloc/emergency_bloc.dart';
import '../../features/contacts/data/datasources/contacts_local_datasource.dart';
import '../../features/contacts/data/repositories/contacts_repository_impl.dart';
import '../../features/contacts/domain/repositories/contacts_repository.dart';
import '../../features/contacts/domain/usecases/add_contact.dart';
import '../../features/contacts/domain/usecases/delete_contact.dart';
import '../../features/contacts/domain/usecases/get_contacts.dart';
import '../../features/contacts/presentation/bloc/contacts_bloc.dart';
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings.dart';
import '../../features/settings/domain/usecases/update_settings.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());

  // Data sources
  getIt.registerLazySingleton<EmergencyRemoteDataSource>(
    () => EmergencyRemoteDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<EmergencyLocalDataSource>(
    () => EmergencyLocalDataSourceImpl(sharedPreferences: getIt()),
  );
  getIt.registerLazySingleton<ContactsLocalDataSource>(
    () => ContactsLocalDataSourceImpl(sharedPreferences: getIt()),
  );
  getIt.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<EmergencyRepository>(
    () => EmergencyRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<ContactsRepository>(
    () => ContactsRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: getIt()),
  );

  // Use cases - Emergency
  getIt.registerLazySingleton(() => TriggerEmergency(getIt()));
  getIt.registerLazySingleton(() => CancelEmergency(getIt()));
  getIt.registerLazySingleton(() => GetCurrentLocation(getIt()));

  // Use cases - Contacts
  getIt.registerLazySingleton(() => AddContact(getIt()));
  getIt.registerLazySingleton(() => DeleteContact(getIt()));
  getIt.registerLazySingleton(() => GetContacts(getIt()));

  // Use cases - Settings
  getIt.registerLazySingleton(() => GetSettings(getIt()));
  getIt.registerLazySingleton(() => UpdateSettings(getIt()));

  // Bloc
  getIt.registerFactory(
    () => EmergencyBloc(
      triggerEmergency: getIt(),
      cancelEmergency: getIt(),
      getCurrentLocation: getIt(),
    ),
  );
  getIt.registerFactory(
    () => ContactsBloc(
      addContact: getIt(),
      deleteContact: getIt(),
      getContacts: getIt(),
    ),
  );
  getIt.registerFactory(
    () => SettingsBloc(
      getSettings: getIt(),
      updateSettings: getIt(),
    ),
  );
}
