package aima.gui.demo.search;

import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import aima.core.agent.Action;
import aima.core.environment.jars.JarsJar;
import aima.core.environment.jars.JarsProblem;
import aima.core.environment.jars.JarsProblemFunctionFactory;
import aima.core.environment.jars.JarsProblemGoalTest;
import aima.core.environment.jars.SimpleHeuristic;
import aima.core.search.framework.GraphSearch;
import aima.core.search.framework.Problem;
import aima.core.search.framework.Search;
import aima.core.search.framework.SearchAgent;
import aima.core.search.informed.AStarSearch;
import aima.core.search.uninformed.BreadthFirstSearch;
import aima.core.search.uninformed.DepthLimitedSearch;
import aima.core.search.uninformed.IterativeDeepeningSearch;

public class JarsProblemDemo {
	
	static JarsProblem jarsExample = new JarsProblem(new JarsJar(4,0),new JarsJar(3,0)); //Solution to our problem
	
	/** The main method invokes the different searches for the problem
	 * @param args
	 */
	public static void main(String[] args) {
		JarsBreadthFirstSearch();
		JarsProblemDLS();
		//JarsProblemIDLS();
		JarsProblemAStar();
	}
	
	private static void JarsBreadthFirstSearch(){
		System.out.println("Breadth First");
		try{
			Problem problem = new Problem(jarsExample,JarsProblemFunctionFactory.getActionsFuction(),
					JarsProblemFunctionFactory.getResultFunction(),new JarsProblemGoalTest());
			Search search = new BreadthFirstSearch();
			SearchAgent agent = new SearchAgent(problem, search);
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation());
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private static void JarsProblemAStar(){
		System.out.println("A*");
		try{
			Problem problem = new Problem(jarsExample,JarsProblemFunctionFactory.getActionsFuction(),
					JarsProblemFunctionFactory.getResultFunction(),new JarsProblemGoalTest());
			Search search = new AStarSearch(new GraphSearch(), new SimpleHeuristic());
			SearchAgent agent = new SearchAgent(problem, search);
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation());
		}catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private static void JarsProblemIDLS() {
		System.out.println("Iterative Depth Limited Search: ->");
		try{
			Problem problem = new Problem(jarsExample,JarsProblemFunctionFactory.getActionsFuction(),
					JarsProblemFunctionFactory.getResultFunction(),new JarsProblemGoalTest());
			Search search = new IterativeDeepeningSearch();
			SearchAgent agent = new SearchAgent(problem, search);
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation());
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Problem is defined as a depth limited search.
	 */
	private static void JarsProblemDLS(){
		System.out.println("Depth Limited Search: ->");
		try{
			Problem problem = new Problem(jarsExample,JarsProblemFunctionFactory.getActionsFuction(),
					JarsProblemFunctionFactory.getResultFunction(),new JarsProblemGoalTest());
			Search search = new DepthLimitedSearch(9);
			SearchAgent agent = new SearchAgent(problem, search);
			printActions(agent.getActions());
			printInstrumentation(agent.getInstrumentation());
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static void printInstrumentation(Properties properties) {
		Iterator<Object> keys = properties.keySet().iterator();
		while (keys.hasNext()) {
			String key = (String) keys.next();
			String property = properties.getProperty(key);
			System.out.println(key + " : " + property);
		}

	}

	private static void printActions(List<Action> actions) {
		for (int i = 0; i < actions.size(); i++) {
			String action = actions.get(i).toString();
			System.out.println(action);
		}
	}
	
	
		

}
