package ieci.tecdoc.sgm.rpadmin.beans;

public class IDocArchsHDRImpl  extends ColeccionGeneralImpl{

	public IDocArchHDRImpl get(int index) {
		return (IDocArchHDRImpl)lista.get(index);
	}

	public void add(IDocArchHDRImpl tipo) {
		lista.add(tipo);
	}
}
