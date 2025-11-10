import React, { useState, useEffect } from 'react';
import { View, Text, TouchableOpacity, ScrollView, StyleSheet } from 'react-native';
import CryptoProRutokenAPI from '../src/index';

export default function App() {
  const [version, setVersion] = useState('');
  const [certificates, setCertificates] = useState([]);
  const [tokens, setTokens] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    setLoading(true);
    setError('');
    try {
      const v = await CryptoProRutokenAPI.getVersion();
      setVersion(v);

      const certs = await CryptoProRutokenAPI.getAvailableCertificates();
      setCertificates(certs);

      const toks = await CryptoProRutokenAPI.getAvailableTokens();
      setTokens(toks);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error');
    }
    setLoading(false);
  };

  const handleSignDocument = async () => {
    try {
      const result = await CryptoProRutokenAPI.signDocument({
        documentPath: '/tmp/test.txt',
        detached: true
      });
      if (result.success) {
        setError('Document signed successfully');
      } else {
        setError(result.error || 'Sign failed');
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Sign error');
    }
  };

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.title}>CryptoPro Rutoken</Text>

      {error && <Text style={styles.error}>{error}</Text>}

      <TouchableOpacity style={styles.button} onPress={loadData} disabled={loading}>
        <Text style={styles.buttonText}>{loading ? 'Loading...' : 'Refresh'}</Text>
      </TouchableOpacity>

      <TouchableOpacity style={styles.button} onPress={handleSignDocument}>
        <Text style={styles.buttonText}>Sign Document</Text>
      </TouchableOpacity>

      <Text style={styles.label}>Version: {version}</Text>

      <Text style={styles.sectionTitle}>Certificates ({certificates.length})</Text>
      {certificates.map((cert, idx) => (
        <View key={idx} style={styles.item}>
          <Text style={styles.itemText}>Thumbprint: {cert.thumbprint || 'N/A'}</Text>
          <Text style={styles.itemText}>Subject: {cert.subjectName || 'N/A'}</Text>
        </View>
      ))}

      <Text style={styles.sectionTitle}>Tokens ({tokens.length})</Text>
      {tokens.map((token, idx) => (
        <View key={idx} style={styles.item}>
          <Text style={styles.itemText}>Serial: {token.serialNumber}</Text>
          <Text style={styles.itemText}>Label: {token.label}</Text>
          <Text style={styles.itemText}>Available: {token.isAvailable ? 'Yes' : 'No'}</Text>
        </View>
      ))}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: '#fff'
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 16
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    marginTop: 16,
    marginBottom: 8
  },
  button: {
    backgroundColor: '#007AFF',
    padding: 12,
    borderRadius: 8,
    marginBottom: 8
  },
  buttonText: {
    color: '#fff',
    textAlign: 'center',
    fontWeight: '600'
  },
  label: {
    fontSize: 16,
    marginVertical: 8
  },
  item: {
    backgroundColor: '#f5f5f5',
    padding: 12,
    borderRadius: 8,
    marginBottom: 8
  },
  itemText: {
    fontSize: 14,
    marginBottom: 4
  },
  error: {
    color: '#ff3b30',
    marginBottom: 8,
    padding: 8,
    backgroundColor: '#fff0f0',
    borderRadius: 8
  }
});
