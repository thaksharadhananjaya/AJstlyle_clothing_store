part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class LoadedProduct extends ProductState{
  final List<Product> productList;
  LoadedProduct({this.productList});
  List<Object> get props => [this.productList];
}


class ProductErrorState extends ProductState{
  final String message;
  ProductErrorState({this.message});
  List<Object> get props => [this.message];
}
