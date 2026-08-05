/// Layout types for home sections
enum SectionLayout {
  gridCategories, // شبكة تبويبات/تصنيفات
  gridBrands, // شبكة علامات تجارية
  gridProducts, // شبكة منتجات
  carouselProducts, // سلايدر منتجات
  banner, // بانر واحد
  mixed, // خليط عناصر مختلفة
  tabsCategories, // تبويبات تصنيفات (الهيدر فقط)
  tabsBrands, // تبويبات علامات تجارية (الهيدر فقط)
}

/// Extension for SectionLayout enum
extension SectionLayoutExtension on SectionLayout {
  /// Get enum key for JSON serialization
  String get key {
    switch (this) {
      case SectionLayout.gridCategories:
        return 'grid_categories';
      case SectionLayout.gridProducts:
        return 'grid_products';
      case SectionLayout.carouselProducts:
        return 'carousel_products';
      case SectionLayout.banner:
        return 'banner';
      case SectionLayout.mixed:
        return 'mixed';
      case SectionLayout.tabsCategories:
        return 'tabs_categories';
      case SectionLayout.gridBrands:
        return 'grid_brands';
      case SectionLayout.tabsBrands:
        return 'tabs_brands';
    }
  }

  /// Get enum label for display
  String get label {
    switch (this) {
      case SectionLayout.gridCategories:
        return 'شبكة تصنيفات';
      case SectionLayout.gridProducts:
        return 'شبكة منتجات';
      case SectionLayout.carouselProducts:
        return 'سلايدر منتجات';
      case SectionLayout.banner:
        return 'بانر';
      case SectionLayout.mixed:
        return 'مختلط';
      case SectionLayout.tabsCategories:
        return 'تبويبات تصنيفات';
      case SectionLayout.gridBrands:
        return 'شبكة علامات تجارية';
      case SectionLayout.tabsBrands:
        return 'تبويبات علامات تجارية';
    }
  }
}

/// Helper class for SectionLayout
class SectionLayoutHelper {
  /// Create enum from key string
  static SectionLayout fromKey(String key) {
    switch (key) {
      case 'grid_categories':
        return SectionLayout.gridCategories;
      case 'grid_products':
        return SectionLayout.gridProducts;
      case 'carousel_products':
        return SectionLayout.carouselProducts;
      case 'banner':
        return SectionLayout.banner;
      case 'mixed':
        return SectionLayout.mixed;
      case 'tabs_categories':
        return SectionLayout.tabsCategories;
      case 'grid_brands':
        return SectionLayout.gridBrands;
      case 'tabs_brands':
        return SectionLayout.tabsBrands;
      default:
        throw ArgumentError('Invalid SectionLayout key: $key');
    }
  }

  /// Get all enum keys
  static List<String> get allKeys {
    return SectionLayout.values.map((e) => e.key).toList();
  }
}

/// Item types for section items
enum SectionItemType {
  product, // منتج
  category, // تصنيف
  brand, // علامة تجارية
  offer, // عرض
  banner, // بانر
}

/// Extension for SectionItemType enum
extension SectionItemTypeExtension on SectionItemType {
  /// Get enum key for JSON serialization
  String get key {
    switch (this) {
      case SectionItemType.product:
        return 'product';
      case SectionItemType.category:
        return 'category';
      case SectionItemType.brand:
        return 'brand';
      case SectionItemType.offer:
        return 'offer';
      case SectionItemType.banner:
        return 'banner';
    }
  }

  /// Get enum label for display
  String get label {
    switch (this) {
      case SectionItemType.product:
        return 'منتج';
      case SectionItemType.category:
        return 'تصنيف';
      case SectionItemType.brand:
        return 'علامة تجارية';
      case SectionItemType.offer:
        return 'عرض';
      case SectionItemType.banner:
        return 'بانر';
    }
  }
}

/// Helper class for SectionItemType
class SectionItemTypeHelper {
  /// Create enum from key string
  static SectionItemType fromKey(String key) {
    switch (key) {
      case 'product':
        return SectionItemType.product;
      case 'category':
        return SectionItemType.category;
      case 'brand':
        return SectionItemType.brand;
      case 'offer':
        return SectionItemType.offer;
      case 'banner':
        return SectionItemType.banner;
      default:
        throw ArgumentError('Invalid SectionItemType key: $key');
    }
  }

  /// Get all enum keys
  static List<String> get allKeys {
    return SectionItemType.values.map((e) => e.key).toList();
  }
}

/// Data source types for sections
enum SectionDataSource {
  manual, // عناصر يدوية من section_items
  category, // منتجات تصنيف
  brand, // منتجات علامة
  offer, // منتجات عرض
  campaign, // منتجات حملة
  flashSaleCurrent, // منتجات فلاش الحالي
  query, // شروط مرنة JSON (min_price, sort, limit...)
}

/// Extension for SectionDataSource enum
extension SectionDataSourceExtension on SectionDataSource {
  /// Get enum key for JSON serialization
  String get key {
    switch (this) {
      case SectionDataSource.manual:
        return 'manual';
      case SectionDataSource.category:
        return 'category';
      case SectionDataSource.brand:
        return 'brand';
      case SectionDataSource.offer:
        return 'offer';
      case SectionDataSource.campaign:
        return 'campaign';
      case SectionDataSource.flashSaleCurrent:
        return 'flash_sale_current';
      case SectionDataSource.query:
        return 'query';
    }
  }

  /// Get enum label for display
  String get label {
    switch (this) {
      case SectionDataSource.manual:
        return 'يدوي';
      case SectionDataSource.category:
        return 'تصنيف';
      case SectionDataSource.brand:
        return 'علامة تجارية';
      case SectionDataSource.offer:
        return 'عرض';
      case SectionDataSource.campaign:
        return 'حملة';
      case SectionDataSource.flashSaleCurrent:
        return 'تخفيض سريع حالي';
      case SectionDataSource.query:
        return 'استعلام';
    }
  }
}

/// Helper class for SectionDataSource
class SectionDataSourceHelper {
  /// Create enum from key string
  static SectionDataSource fromKey(String key) {
    switch (key) {
      case 'manual':
        return SectionDataSource.manual;
      case 'category':
        return SectionDataSource.category;
      case 'brand':
        return SectionDataSource.brand;
      case 'offer':
        return SectionDataSource.offer;
      case 'campaign':
        return SectionDataSource.campaign;
      case 'flash_sale_current':
        return SectionDataSource.flashSaleCurrent;
      case 'query':
        return SectionDataSource.query;
      default:
        throw ArgumentError('Invalid SectionDataSource key: $key');
    }
  }

  /// Get all enum keys
  static List<String> get allKeys {
    return SectionDataSource.values.map((e) => e.key).toList();
  }
}
