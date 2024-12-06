package entidad;

import java.math.BigDecimal;

public class TipoPrestamo {
	private int idTipoPrestamo;
	private String nombreTipoPrestamo;
	private BigDecimal tna; // (Tasa Nominal Anual) representa el porcentaje de interés que se aplica según el tipo de préstamo
	
	public TipoPrestamo() {
		
	}
	
	public TipoPrestamo(int idTipoPrestamo, String nombreTipoPrestamo, BigDecimal tna) {
		super(); 
		this.idTipoPrestamo = idTipoPrestamo;
		this.nombreTipoPrestamo = nombreTipoPrestamo;
		this.tna = tna;
	}

	public int getIdTipoPrestamo() {
		return idTipoPrestamo;
	}

	public void setIdTipoPrestamo(int idTipoPrestamo) {
		this.idTipoPrestamo = idTipoPrestamo;
	}

	public String getNombreTipoPrestamo() {
		return nombreTipoPrestamo;
	}

	public void setNombreTipoPrestamo(String nombreTipoPrestamo) {
		this.nombreTipoPrestamo = nombreTipoPrestamo;
	}

	public BigDecimal getTna() {
		return tna;
	}

	public void setTna(BigDecimal bigDecimal) {
		this.tna = bigDecimal;
	}
}