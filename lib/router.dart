import 'package:go_router/go_router.dart';
import 'package:json_schema_validate/features/core/presentation/pages/schema_validate_page.dart';

final kRouter = GoRouter(
  routes: [
    GoRoute(path: '/', redirect: (context, state) => '/validate'),
    GoRoute(
      path: '/validate',
      builder: (context, state) => SchemaValidatePage(
        schema: state.uri.queryParameters['schema'],
      ),
    ),
  ],
);
