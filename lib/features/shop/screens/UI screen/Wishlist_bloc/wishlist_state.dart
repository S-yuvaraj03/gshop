part of 'wishlist_bloc.dart';


class WishlistState extends Equatable {
  final List<Product> wishlist;

  const WishlistState({this.wishlist = const []});

  @override
  List<Object> get props => [wishlist];
}

class WishlistInitial extends WishlistState {}

class WishlistUpdated extends WishlistState {
  const WishlistUpdated(List<Product> wishlist) : super(wishlist: wishlist);
}

