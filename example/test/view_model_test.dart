import 'package:arch/arch.dart';
import 'package:arch_example/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks/mock_services.dart';

void main() {
  group('HomeViewModel', () {
    HomeViewModel viewModel;
    NavigationService navigationService;

    setUp(() {
      navigationService = MockNavigationService();
      viewModel = HomeViewModel(navigationService);
    });

    test('Verify counter incremented', () {
      // Act
      viewModel.counter++;

      // Assert
      expect(viewModel.counter, 1);
    });

    test('Navigates to SecondView', () async {
      // Act
      await viewModel.navigate();

      // Assert
      verify(navigationService.push('SecondView', any)).called(1);
    });
  });
}
