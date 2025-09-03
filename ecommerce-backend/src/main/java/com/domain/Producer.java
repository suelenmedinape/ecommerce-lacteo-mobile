package com.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table(name = "tb_producer")
public class Producer extends Person{

	private static final long serialVersionUID = 1L;
	
	@Column(unique = true)
	private String cnpj;
	
	public Producer() {
		
	}
	
	public String getCnpj() {
		return cnpj;
	}
	
	public void setCnpj(String cnpj) {
		this.cnpj = cnpj;
	}
}
