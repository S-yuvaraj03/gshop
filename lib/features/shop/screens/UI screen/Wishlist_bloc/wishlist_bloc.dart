import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gshop/features/shop/model/ProductModel.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(WishlistInitial()) {
    on<AddProductToWishlist>(_onAddProductToWishlist);
    on<RemoveProductFromWishlist>(_onRemoveProductFromWishlist);
  }

  void _onAddProductToWishlist(
      AddProductToWishlist event, Emitter<WishlistState> emit) {
    final updatedWishlist = List<Product>.from(state.wishlist)
      ..add(event.product);
    emit(WishlistUpdated(updatedWishlist));
  }

  void _onRemoveProductFromWishlist(
      RemoveProductFromWishlist event, Emitter<WishlistState> emit) {
    final updatedWishlist = List<Product>.from(state.wishlist)
      ..remove(event.product);
    emit(WishlistUpdated(updatedWishlist));
  }
}

