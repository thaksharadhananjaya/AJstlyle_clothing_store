part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class FetchProduct extends ProductEvent{
  FetchProduct();
}

class ReloadProduct extends ProductEvent{
  ReloadProduct();
}
