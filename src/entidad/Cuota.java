package entidad;

import java.math.BigDecimal;
import java.sql.Date;

public class Cuota {
	private int idPlazo;
	private int numeroDeCuota;
	private Date fechaVencimientoCuota;
	private Date fechaPagoCuota;
	private BigDecimal importeCuota;
	private int estado;

	public Cuota() {
		
	}
	
	public int getIdPlazo() {
		return idPlazo;
	}

	public void setIdPlazo(int idPlazo) {
		this.idPlazo = idPlazo;
	}

	public int getNumeroDeCuota() {
		return numeroDeCuota;
	}

	public void setNumeroDeCuota(int numeroDeCuota) {
		this.numeroDeCuota = numeroDeCuota;
	}

	public Date getFechaVencimientoCuota() {
		return fechaVencimientoCuota;
	}

	public void setFechaVencimientoCuota(Date fechaVencimientoCuota) {
		this.fechaVencimientoCuota = fechaVencimientoCuota;
	}

	public Date getFechaPagoCuota() {
		return fechaPagoCuota;
	}

	public void setFechaPagoCuota(Date fechaPagoCuota) {
		this.fechaPagoCuota = fechaPagoCuota;
	}

	public BigDecimal getImporteCuota() {
		return importeCuota;
	}

	public void setImporteCuota(BigDecimal importeCuota) {
		this.importeCuota = importeCuota;
	}

	public int isEstado() {
		return estado;
	}

	public void setEstado(int estado) {
		this.estado = estado;
	}
	
	
}
