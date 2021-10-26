import 'package:ajstyle/models/productModel.dart';
import 'package:ajstyle/respositories/product_respo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final bool isSale;
  final String search;
  final int categoryID;
  ProductBloc(this.isSale, this.search, this.categoryID)
      : super(ProductInitial());
  List<Product> productList = [];
  ProductRepo productRepo = ProductRepo();
  int page = -5;
  bool isLoading = false;
  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is FetchProduct) {
      if (!isLoading) {
        isLoading = true;
        page += 5;
        List<Product> list =
            await productRepo.getProduct(isSale, page, categoryID, search);
        try {
          if (list == null) {
            if (productList.length > 0) {
              page -= 5;
              yield LoadedProduct(productList: productList);
            } else {
              yield search != null
                  ? ProductErrorState(message: "Search result not found !")
                  : ProductErrorState(message: "Not found product");
            }
          } else {
            productList.addAll(list);
            yield LoadedProduct(productList: productList);
          }
        } catch (e) {
          page -= 5;
          yield ProductErrorState(message: "Error !");
        }
        isLoading = false;
      }
    } else if (event is ReloadProduct) {
      yield null;
      productList.clear();
      List<Product> list =
          await productRepo.getProduct(isSale, 0, categoryID, search);
      try {
        if (list == null) {
          yield ProductErrorState(message: "Empty");
        } else {
          productList.addAll(list);
          yield LoadedProduct(productList: productList);
        }
      } catch (e) {
        yield ProductErrorState(message: "Error !");
      }
    }
  }
}
