import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gshop/data/repositories/fetch_data/fetchdata.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gshop/features/shop/model/ShopModel.dart';

part 'shop_event.dart';
part 'shop_state.dart';


class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final Future<List<Shop>> Function() fetchShops;

  ShopBloc(this.fetchShops) : super(ShopInitial()) {
    on<FetchShops>((event, emit) async {
      emit(ShopLoading());
      try {
        final shops = await fetchShops();
        emit(ShopLoaded(shops));
      } catch (e) {
        emit(ShopError(e.toString()));
      }
    });
  }
}
