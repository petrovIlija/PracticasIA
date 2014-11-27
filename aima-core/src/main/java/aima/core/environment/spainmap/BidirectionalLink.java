package aima.core.environment.spainmap;

public class BidirectionalLink {

	private City _firstCity,_secondCity; 
	private int _roadDistance;
	
	/**
	 * Default Constructor, Should not be used.
	 */
	BidirectionalLink(){
		_firstCity = new City();
		_secondCity = new City();
		_roadDistance = 0;
	}
	
	/** Parameter constructor for a bidirectional Link
	 * @param first One of the cities that are linked.
	 * @param second The other city that is linked.
	 * @param distance The distance of the road between them.
	 */
	BidirectionalLink(City first, City second, int distance){
		_firstCity = first;
		_secondCity = second;
		_roadDistance = distance;
	}
	
	public City getFirstCity (){
		return _firstCity;
	}
	
	public City getSecondCity(){
		return _secondCity;
	}
	
	public int getRoadDistance(){
		return _roadDistance;
	}
}
