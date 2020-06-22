struct Category: Codable {
    /// ИД категории
    let id: Int
    /// Название категории
    let title: String
    /// ИД родительской категории
    let parent_id: Int?
}
