package entidad;

import java.math.BigDecimal;
import java.sql.Date;

public class Prestamo{
	private int idPrestamo;
	private int dniCliente;
	private BigDecimal montoPedido;
	private BigDecimal montoAPagar;
	private int cuotas;
	private int cuotasPagas;
	private Date fecha;
	TipoPrestamo tipoPrestamo;
	private int estado;
	private Cliente cliente;
	private Cuenta cuenta;
	Movimiento movimiento;
	
	public Prestamo() {
		super();
	}

	public Prestamo(int idPrestamo, int dniCliente, BigDecimal montoPedido, BigDecimal montoAPagar, int cuotas, Date fecha, int estado) {
		super();
		this.idPrestamo = idPrestamo;
		this.dniCliente = dniCliente;
		this.montoPedido = montoPedido;
		this.montoAPagar = montoAPagar;
		this.cuotas = cuotas;
		this.fecha = fecha;
		this.estado = estado;
	}
	public int getCuotasPagas() {
		return cuotasPagas;
	}

	public void setCuotasPagas(int cuotasPagas) {
		this.cuotasPagas = cuotasPagas;
	}

	public Movimiento getMovimiento() {
		return movimiento;
	}

	public void setMovimiento(Movimiento movimiento) {
		this.movimiento = movimiento;
	}

	public Cliente getCliente() {
		return cliente;
	}

	public void setCliente(Cliente cliente) {
		this.cliente = cliente;
	}

	public Cuenta getCuenta() {
		return cuenta;
	}

	public void setCuenta(Cuenta cuenta) {
		this.cuenta = cuenta;
	}

	public TipoPrestamo getTipoPrestamo() {
		return tipoPrestamo;
	}

	public void setTipoPrestamo(TipoPrestamo tipoPrestamo) {
		this.tipoPrestamo = tipoPrestamo;
	}

	public int getIdPrestamo() {
		return idPrestamo;
	}

	public void setIdPrestamo(int idPrestamo) {
		this.idPrestamo = idPrestamo;
	}

	public int getDniCliente() {
		return dniCliente;
	}

	public void setDniCliente(int dniCliente) {
		this.dniCliente = dniCliente;
	}

	public BigDecimal getMontoPedido() {
		return montoPedido;
	}

	public void setMontoPedido(BigDecimal montoPedido) {
		this.montoPedido = montoPedido;
	}

	public BigDecimal getMontoAPagar() {
		return montoAPagar;
	}

	public void setMontoAPagar(BigDecimal montoAPagar) {
		this.montoAPagar = montoAPagar;
	}

	public int getCuotas() {
		return cuotas;
	}

	public void setCuotas(int cuotas) {
		this.cuotas = cuotas;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public int getEstado() {
		return estado;
	}

	public void setEstado(int estado) {
		this.estado = estado;
	}
	
}