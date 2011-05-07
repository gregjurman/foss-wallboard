/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 */
import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageConsumer;
import javax.jms.MessageListener;
import javax.jms.MessageProducer;
import javax.jms.Queue;
import javax.jms.Session;
import javax.jms.TextMessage;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import java.util.Properties;

public interface QPidCallback {
  void handleTextMessage(String message);
}

public class QPidClient implements MessageListener
{
    final String BROKER = "ectet-esd3.rit.edu";

    final String INITIAL_CONTEXT_FACTORY = "org.apache.qpid.jndi.PropertiesFileInitialContextFactory";

    final String CONNECTION_JNDI_NAME = "local";
    final String CONNECTION_NAME = "amqp://guest:guest@clientid/?brokerlist='" + BROKER + "'";

    final String QUEUE_JNDI_NAME = "nepotism_forwarder";
    final String QUEUE_NAME = QUEUE_JNDI_NAME;


    private InitialContext _ctx;
    final private QPidCallback _cb;
    
    public QPidClient(QPidCallback _callback)
    {
        setupJNDI();
        _cb = _callback;

        Connection connection;
        Session session;
        try
        {
            connection = ((ConnectionFactory) lookupJNDI(CONNECTION_JNDI_NAME)).createConnection();

            session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);

            //Create a temporary queue that this client will listen for responses on then create a consumer
            //that consumes message from this temporary queue.
            
            Destination destination = (Destination) _ctx.lookup(QUEUE_NAME);

            MessageConsumer responseConsumer = session.createConsumer(destination);

            //Set a listener to asynchronously deal with responses.
            responseConsumer.setMessageListener(this);

            // Now the connection is setup up start it.
            connection.start();
        }
        catch (JMSException e)
        {
            System.err.println(e);
            System.err.println("Unable to setup connection, client and producer on broker");
            return;
        }
        catch (Exception e) {
          e.printStackTrace();
        }
    }

    /**
     * Implementation of the Message Listener interface.
     * This is where message will be asynchronously delivered.
     *
     * @param message
     */
    public void onMessage(Message message)
    {
        String messageText;
        
        JMSBytesMessage jmsMessage = (JMSBytesMessage) message;
        try
        {
            byte[] tmp = new byte[1024];
            messageText = "";
            int readBytes = jmsMessage.readBytes(tmp);
            while(readBytes > -1)
            {
              messageText+=(new String(tmp, 0,readBytes));
              tmp = null;
              tmp = new byte[1024];
              readBytes = jmsMessage.readBytes(tmp);
            }
            _cb.handleTextMessage(messageText);
            //messageText = textMessage.getText();
            //println("messageText = " + messageText);
            //println("Correlation ID " + message.getJMSCorrelationID());
            jmsMessage.acknowledge();
        }
        catch (Exception e)
        {
            print(e);
        }
    }

    /**
     * Lookup the specified name in the JNDI Context.
     *
     * @param name The string name of the object to lookup
     *
     * @return The object or null if nothing exists for specified name
     */
    private Object lookupJNDI(String name)
    {
        try
        {
            return _ctx.lookup(name);
        }
        catch (Exception e)
        {
            System.err.println("Error looking up '" + name + "' in JNDI Context:" + e);
        }

        return null;
    }

    /**
     * Setup the JNDI context.
     *
     * In this case we are simply using a Properties object to store the pairing information.
     *
     * Further details can be found on the wiki site here:
     *
     * @see : http://cwiki.apache.org/qpid/how-to-use-jndi.html
     */
    private void setupJNDI()
    {
        // Set the properties ...
        Properties properties = new Properties();
        properties.put(Context.INITIAL_CONTEXT_FACTORY, INITIAL_CONTEXT_FACTORY);
        properties.put("connectionfactory." + CONNECTION_JNDI_NAME, CONNECTION_NAME);
        properties.put("queue." + QUEUE_JNDI_NAME, QUEUE_NAME);

        // Create the initial context
        Context ctx = null;
        try
        {
            _ctx = new InitialContext(properties);
        }
        catch (Exception e)
        {
            System.err.println("Error Setting up JNDI Context:" + e);
        }
    }

    /** Close the JNDI Context to keep everything happy. */
    private void closeJNDI()
    {
        try
        {
            _ctx.close();
        }
        catch (NamingException e)
        {
            System.err.println("Unable to close JNDI Context : " + e);
        }
    }
}

