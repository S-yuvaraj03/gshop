import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';



class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final Future<List<Product>> Function() fetchProducts;

  ProductBloc(this.fetchProducts) : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await fetchProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError(e.toString()));
      }
    });
  }
}
