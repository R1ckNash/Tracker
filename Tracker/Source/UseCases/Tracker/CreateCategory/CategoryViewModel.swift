//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Ilia Liasin on 24/02/2025.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    
    // MARK: - Public Properties
    
    var selectedCategory: String?
    var onCategoriesUpdated: Binding<[String]>?
    var onError: Binding<String?>?
    
    // MARK: - Initializers
    
    init() {
        loadCategories()
    }
    
    // MARK: - Private Properties
    
    private lazy var dataProvider: DataProvider = {
        DIContainer.shared.makeDataProvider()
    }()
    
    private var categories: [String] = [] {
        didSet {
            onCategoriesUpdated?(categories)
        }
    }
    
    // MARK: - Public Methods
    
    func addCategory(_ category: String) {
        dataProvider.createTrackerCategory(categoryTitle: category)
    }
    
    func getCategories() -> [String] {
        categories
    }
    
    func getCategoriesCount() -> Int {
        categories.count
    }
    
    func isCategorySelected(_ category: String) -> Bool {
        category == selectedCategory
    }
    
    func selectCategory(_ category: String) {
        selectedCategory = category
    }
    
    func loadCategories() {
        categories = dataProvider.getAllCategoryTitles()
    }
    
}

