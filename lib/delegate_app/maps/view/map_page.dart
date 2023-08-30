import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/map_bloc.dart';
import '../map_repository/src/map_repository.dart';
import 'map_view.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key, required this.mapRepository, required this.state});

  final MapRepository mapRepository;
  final String state;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: mapRepository,
      child: BlocProvider(
        create: (context) => MapBloc(mapRepository),
        child: MapView(
          state: state,
        ),
      ),
    );
  }
}
