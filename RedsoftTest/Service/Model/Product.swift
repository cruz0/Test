struct Product: Codable {
    /// ИД товара
    let id: Int
    /// Название товара
    let title: String
    /// Краткое описание товара
    let short_description: String
    /// Ссылка на картинку
    let image_url: String
    /// Количество на складе
    let amount: Int
    /// Цена
    let price: Double
    /// Производитель
    let producer: String
    /// Список категорий
    let categories: [Category]
}
