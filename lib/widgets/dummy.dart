import 'package:textile/views/drawer/textile_importers/buyer_model.dart';


class DummyData {
  static List<BuyerModel> getBuyers() {
    return [
      BuyerModel(id: '1011739', importerName: 'DE WITTE LIETAER INTERNATIONAL TEXTILES.', 
        country: 'Belgium', productCategory: 'Bed linen / bed sheet', ranking: 'High', buyersWorth: 2283513.46),
      BuyerModel(id: '1502502', importerName: 'BRYAN LEE YORK', 
        country: 'Belgium', productCategory: 'Used Clothes', ranking: 'Medium', buyersWorth: 141550.00),
      BuyerModel(id: '1348752', importerName: 'STUDIO', 
        country: 'Belgium', productCategory: 'Duvet Covers', ranking: 'High', buyersWorth: 6517523.72),
      BuyerModel(id: '853649', importerName: 'CÔTE DAMOUR', 
        country: 'Belgium', productCategory: 'Bed linen / bed sheet', ranking: 'High', buyersWorth: 68578409.00),
      BuyerModel(id: '716150', importerName: 'M/S MCO', 
        country: 'Belgium', productCategory: 'Terry Towels', ranking: 'Low', buyersWorth: 915.00),
      BuyerModel(id: '999803', importerName: 'EL BADR DISTRIBUTION INTERNATIONALE', 
        country: 'Belgium', productCategory: 'Prayer Mats', ranking: 'Medium', buyersWorth: 614460.00),
      BuyerModel(id: '845621', importerName: 'GLOBAL TEXTILES LTD', 
        country: 'Belgium', productCategory: 'Bed Spreads', ranking: 'High', buyersWorth: 3245678.90),
      BuyerModel(id: '923456', importerName: 'EURO FABRICS COMPANY', 
        country: 'Belgium', productCategory: 'Blankets', ranking: 'Medium', buyersWorth: 892345.50),
    ];
  }

  static List<String> getCountries() {
    return ['Belgium', 'USA', 'UK', 'Germany', 'France', 'Italy', 'Spain', 'Netherlands'];
  }

  static List<String> getProductCategories() {
    return ['All', 'Bed Linen / Bed Sheet', 'Bed Spreads', 'Belts', 'Blankets', 
            'Bags', 'Duvet Covers', 'Prayer Mats', 'Terry Towels', 'Used Clothes'];
  }

  static List<String> getBuyerRankings() {
    return ['All', 'High To Low', 'Low to High'];
  }
}