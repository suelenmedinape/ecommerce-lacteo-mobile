package com.dtos;

import java.math.BigDecimal;

import com.domain.Product;
import com.enums.Category;

public class ProductSummaryDTO {
	
	private Long id;
	private String productName;
	private BigDecimal price;
	private Integer quantity;
	private Category category;
	private String imageUrl;

	public ProductSummaryDTO() {
	}
	
	public ProductSummaryDTO(Long id, String productName, BigDecimal price, Integer quantity, Category category, String imageUrl) {
		super();
		this.id = id;
		this.productName = productName;
		this.price = price;
		this.quantity = quantity;
		this.category = category;
		this.imageUrl = imageUrl;
	}



	public ProductSummaryDTO(Product product) {
		this.id = product.getId();
		this.productName = product.getProductName();
		this.price = product.getPrice();
		this.quantity = product.getQuantity();
		this.category = product.getCategories();
		this.imageUrl = product.getImageUrl();
	}

	public Long getId() {
		return id;
	}

	public String getProductName() {
		return productName;
	}

	public BigDecimal getPrice() {
		return price;
	}
	
	public String getCategories() {
		return category.getDescricao();
	}

	public void setCategory(String category) {
	    this.category = Category.fromDescricao(category);
	}
	
	public Integer getQuantity() {
		return quantity;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
}
