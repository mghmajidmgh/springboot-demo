import React, { useEffect, useState } from 'react'

export default function App(){
  const [cities, setCities] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetch('/api/cities')
      .then(res => res.json())
      .then(data => setCities(data))
      .catch(err => console.error(err))
      .finally(() => setLoading(false))
  }, [])

  return (
    <div className="container">
      <div className="card">
        <h1>Cities</h1>

        {loading ? (
          <div>Loading...</div>
        ) : (
          <table className="cities-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Country</th>
                <th>Population</th>
              </tr>
            </thead>
            <tbody>
              {cities.map(c => (
                <tr key={c.id}>
                  <td>{c.id}</td>
                  <td>{c.name}</td>
                  <td>{c.country}</td>
                  <td>{c.population}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  )
}
